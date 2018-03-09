class ExportProductImageCsvWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'export_product_image', retry: 0

  MAX_IMAGE_URL_SET_CACHE = 1000
  DB_BATCH_SIZE = 1000 # batch size must < max export rows per file
  MAX_EXPORT_ROWS = 600000

  def perform(system = 'all')
    perform_sync(system)
  end

  def perform_sync(system = 'all')
    unless ENV['PRODUCT_IMAGE_EXPORT_ENABLED'] == 'true'
      return
    end

    if system == 'all'
      calculate_deltas

      # export for one system at a time to avoid memory explosion
      #   http://www.mikeperham.com/2009/05/25/memory-hungry-ruby-daemons/
      # the sequential is controlled in method perform_for(system)
      ExportProductImageCsvWorker.perform_async('bb_viz')
    else
      perform_for(system)
    end
  end

  private

  def calculate_deltas
    Sidekiq.logger.info 'filling delta add...'
    fill_delta_add
    Sidekiq.logger.info 'done'

    Sidekiq.logger.info 'filling delta remove...'
    fill_delta_remove
    Sidekiq.logger.info 'done'

    Sidekiq.logger.info 'deleting delta remove in delta add...'
    delete_delta_remove_from_delta_add
    Sidekiq.logger.info 'done'
  end

  def fill_delta_add
    query_insert = [
        "INSERT INTO #{ProductImageIndexAdd.table_name} (product_id, category_id)",
        'SELECT pc.product_id, pc.category_id',
        "FROM #{ProductCategory.table_name} pc LEFT JOIN #{ProductImageIndexAdd.table_name} pi",
        'ON pc.product_id = pi.product_id AND pc.category_id = pi.category_id',
        "WHERE pi.product_id IS NULL AND pc.category_id != #{Category::QUARANTINE_CATEGORY_ID}",
        'ORDER by pc.product_id asc'
    ].join(' ')

    ActiveRecord::Base.connection.execute(query_insert)
  end

  def fill_delta_remove
    query_remove = [
        "INSERT INTO #{ProductImageIndexRemove.table_name} (product_id, category_id)",
        'SELECT pi.product_id, pi.category_id',
        "FROM #{ProductImageIndexAdd.table_name} pi LEFT JOIN #{ProductCategory.table_name} pc",
        'ON pc.product_id = pi.product_id AND pc.category_id = pi.category_id',
        "WHERE pc.product_id IS NULL AND pc.category_id != #{Category::QUARANTINE_CATEGORY_ID}",
        'ORDER BY pi.product_id asc'
    ].join(' ')

    ActiveRecord::Base.connection.execute(query_remove)
  end

  def delete_delta_remove_from_delta_add
    query_exclude = [
        "DELETE FROM #{ProductImageIndexAdd.table_name}",
        'WHERE (product_id, category_id) in (',
        'SELECT pii.product_id, pii.category_id',
        "FROM #{ProductImageIndexAdd.table_name} pii JOIN #{ProductImageIndexRemove.table_name} pir",
        'ON pii.product_id = pir.product_id AND pii.category_id = pir.category_id',
        ")"
    ].join(' ')

    ActiveRecord::Base.connection.execute(query_exclude)
  end

  def perform_for(system)
    Sidekiq.logger.info "Exporting data for #{system} system"

    total = 0
    case system
      when 'ulab_viz'
        total = export_for_system(system: 'ulab_viz',
                                  excluded_category_ids: Category::ulab_vision_excluded_cat_ids,
                                  csv_header: %w(id name description img_url brand category available),
                                  csv_data_row_converter: :ulab_to_csv)
      when 'bb_viz'
        total = export_for_system(system: 'bb_viz',
                                  excluded_category_ids: Category::bb_vision_excluded_cat_ids,
                                  csv_header: %w(im_name im_url name tenant brand category gender store keywords available),
                                  csv_data_row_converter: :bb_to_csv)
      else
        Sidekiq.logger.error "Unknown system #{system}"
    end

    # trigger another export, this is to prevent OutOfMemory error if exporting large number of product at once
    # When it happens, OS will kill the sidekiq process. Use following command to check if it is the case
    #   dmesg | egrep -i 'killed process'
    # Reference: http://www.sutro-research.com/blog/post/debugging-mysterious-sidekiq-shutdowns
    if total > 0
      ExportProductImageCsvWorker.perform_async(system)
    elsif system == 'bb_viz'
      ExportProductImageCsvWorker.perform_async('ulab_viz')
    end
  end

  def export_for_system(system:, excluded_category_ids:, csv_header:, csv_data_row_converter:)
    running_export = ProductImageCSVExport.where(system: system, running: true)
    unless running_export.blank?
      Sidekiq.logger.info "There is a running export (ID #{running_export[0].id}) for system #{system}"
      return 0
    end

    export = ProductImageCSVExport.create(system: system)

    begin

      file_suffix = DateTime.now.strftime('%Y%m%d%H%M%S')

      # delta remove
      total = export_data(
          table: ProductImageIndexRemove,
          export: export,
          delta: 'remove',
          file_name: "#{system}_#{export.id}_#{file_suffix}_remove_",
          excluded_cat_ids: [],
          csv_header: csv_header,
          csv_data_row_converter: csv_data_row_converter)

      # delta add
      total += export_data(
          table: ProductImageIndexAdd,
          export: export,
          delta: 'add',
          file_name: "#{system}_#{export.id}_#{file_suffix}_add_",
          excluded_cat_ids: excluded_category_ids,
          csv_header: csv_header,
          csv_data_row_converter: csv_data_row_converter)

      if total > 0
        export.update_attributes(running: false)
      else
        export.delete
      end
      return total
    rescue Exception => e
      puts "\n"
      puts e.message
      puts e.backtrace.join("\n")
      export.delete
    end
    0
  end

  def export_data(table:,
                  export:,
                  delta:,
                  file_name:,
                  excluded_cat_ids:,
                  csv_header:,
                  csv_data_row_converter:)
    query = table.where("#{export.system} = ?", false).includes(:product, :category)
    unless excluded_cat_ids.blank?
      query = query.where.not(category_id: excluded_cat_ids)
    end
    # find_in_batches will disabled the order clause. query = query.order(product_id: 'asc')

    total = 0
    csv_file = nil
    begin
      csv_file = TempFileHelper.new_temp_file(file_name, '.csv')
      CSV.open(csv_file.path, 'wb', headers: true) do |csv|
        # Headers
        csv << csv_header
      end

      total = write_csv_in_batch(table: table,
                                 query: query,
                                 delta: delta,
                                 csv_data_row_converter: csv_data_row_converter,
                                 csv_file: csv_file,
                                 export: export,
                                 db_batch_size: DB_BATCH_SIZE,
                                 max_export_rows: MAX_EXPORT_ROWS)

      # Add a new record to database
      if delta == 'add'
        export.delta_add_file = csv_file
        export.delta_add_num = total
      else
        export.delta_remove_file = csv_file
        export.delta_remove_num = total
      end
      export.save!

      # Update status to true
      table.where("#{export.system}_exporting = ?", export.id).update_all(" #{export.system} = true",)
    ensure
      # Delete local tmp file
      TempFileHelper::delete_quite(csv_file)
    end

    total
  end

  def write_csv_in_batch(table:, query:, delta:, csv_data_row_converter:, csv_file:, export:, db_batch_size:, max_export_rows:)
    total_to_process = query.count

    # keep N (big enough to cover maximum number of SKUs of one products) last image urls
    # this is to prevent exporting duplicated SKUs (with same image URL)
    image_set_batches = SortedSet.new

    processed_count = 0
    start_time = Time.now
    total_in_csv = 0
    catch :break_batch do
      ActiveRecord::Base.uncached do
        query.find_in_batches(batch_size: db_batch_size) do |batch|
          written_ids = batch.map { |p| p.id }

          data = prepare_export_data(batch)

          if total_in_csv >= max_export_rows
            first_img_url = get_exported_image_url(data[0])
            # still same product group (SKUs), try next batch
            throw :break_batch unless first_img_url.blank? || duplicated?(first_img_url, image_set_batches)
          end

          batch_rows = []
          data.each do |data_row|
            csv_row = self.send(csv_data_row_converter, data_row, image_set_batches)
            batch_rows << csv_row unless csv_row.blank?
          end

          processed_count += batch.size
          total_in_csv += batch_rows.size
          # Write to csv
          CSV.open(csv_file.path, 'ab', headers: false) do |csv|
            # Batch write to csv
            batch_rows.each { |row| csv << row }
          end

          spent = (Time.now - start_time) # seconds

          progress = "spent: #{pretty_print_duration(spent)}"
          if processed_count < total_to_process && total_in_csv < max_export_rows
            remaining_time = ((total_to_process - processed_count) * spent) / processed_count
            progress = "total/processed #{total_to_process}/#{processed_count}, spent/ETA: #{pretty_print_duration(spent)}/#{pretty_print_duration(remaining_time)}"
          end
          export.progress = progress
          export.save!

          table.where(id: written_ids).update_all("#{export.system}_exporting = #{export.id}")

          data = nil
          batch_rows = nil
          written_ids = nil
          batch = nil
          GC.start
        end
      end
    end

    GC.start

    total_in_csv
  end

  def pretty_print_duration(secs)
    return "%0dms" % (secs * 1000) if secs < 1
    # HH:MM:SS
    "%02d:%02d:%02d" % [secs/3600, secs/60%60, secs%60]
  end

  def prepare_export_data(batch)
    # prepare store ID
    # {'product_id': xx, 'store_id': xxx}
    pid_store_id_arr = Variant.joins(:variant_stores)
                           .where(product_id: batch.map { |p| p.product_id })
                           .select(:product_id, :store_id)
                           .distinct
    pid_to_store_ids = {}
    pid_store_id_arr.each do |ps|
      pid_to_store_ids[ps['product_id']] = ps['store_id']
    end


    all_need_variant_items = []
    batch.each do |prod_to_index|
      if prod_to_index.product.vendor_product_image_url.blank?
        all_need_variant_items << prod_to_index
      end
    end

    pid_to_variant = {}
    unless all_need_variant_items.blank?
      sql = ActiveRecord::Base.send(:sanitize_sql_array, ["
          select id
          from
          (select id, product_id, row_number() OVER(PARTITION BY product_id ORDER BY id ASC) AS rn
          from #{Variant.table_name}
          where product_id in (?)
          ORDER BY product_id, rn) tmp
          where rn = 1", all_need_variant_items.map { |p| p.product_id }])

      variant_ids = ActiveRecord::Base.connection.select_all(sql).map { |v| v['id'] }

      variants = Variant.where(id: variant_ids)
      variants.each do |v|
        pid_to_variant[v.product_id] = v
      end
    end

    aggregated_data = []
    batch.each do |prod_to_index|
      pid = prod_to_index.product_id
      aggregated_data << {
          product: prod_to_index.product,
          category: prod_to_index.category,
          variant: pid_to_variant[pid],
          store_id: pid_to_store_ids[pid]
      }
    end
    aggregated_data
  end

  def ulab_to_csv(data_row, image_set_batches)
    # data_row {
    #     product: prod_to_index.product,
    #     category: prod_to_index.category,
    #     variant: pid_to_variant[pid],
    #     store_id: pid_to_store_ids[pid]
    # }

    ## [id, name]
    csv_item = [
        data_row[:product].id,
        data_row[:product].get_normalized_name || ''
    ]
    ## [description]
    if !data_row[:product].get_normalized_description.blank?
      csv_item << data_row[:product].get_normalized_description
    else
      csv_item << data_row[:variant]&.get_normalized_description || ''
    end

    ## [img_url]
    img_url = get_exported_image_url(data_row)
    if img_url.blank?
      Sidekiq.logger.warn "Skip exporting product #{data_row[:product].id} due to no image URL"
      return []
    end
    return [] if duplicated?(img_url, image_set_batches)
    csv_item << img_url

    ## [brand, category, available]
    csv_item.push(data_row[:product].get_normalized_brand || '')
    csv_item.push(data_row[:category].display_name || '')

    ## [available]
    csv_item.push(to_availability(data_row))

    csv_item
  end

  def to_availability data_row
    data_row[:product].available ? 'TRUE' : 'FALSE'
  end

  def duplicated?(img_url, image_set_batches)
    return true if img_url.blank? || image_set_batches.include?(img_url)
    image_set_batches << img_url
    image_set_batches.subtract(image_set_batches.take(1)) if image_set_batches.size > MAX_IMAGE_URL_SET_CACHE
    false
  end

  def get_exported_image_url(data_row)
    img_url = Product::fix_buggy_image_url(data_row[:product].vendor_product_image_url)
    if img_url.blank?
      img_url = Product::fix_buggy_image_url(get_image_url_from_variant(data_row[:variant]))
    end
    img_url
  end

  def get_image_url_from_variant(variant)
    return nil if variant.blank?
    variant_images = variant.get_variant_image_url
    img_url = nil

    variant_images.each { |variant_image|
      if img_url.blank?
        img_url = variant_image.large_cover_image_url unless variant_image.large_cover_image_url.blank?
        img_url = variant_image.small_cover_image_url unless variant_image.small_cover_image_url.blank?
        img_url = variant_image.thumb_cover_image_url unless variant_image.thumb_cover_image_url.blank?
      else
        break;
      end
    }
    img_url
  end

  def bb_to_csv(data_row, image_set_batches)
    # %w(im_name im_url name tenant brand category gender store keywords),

    ## [im_name]
    csv_item = [
        data_row[:product].id
    ]

    ## [im_url]
    img_url = get_exported_image_url(data_row)
    if img_url.blank?
      Sidekiq.logger.warn "Skip exporting product #{data_row[:product].id} due to no image URL"
      return []
    end
    return [] if duplicated?(img_url, image_set_batches)
    csv_item << img_url

    ## [name]
    csv_item.push(data_row[:product].get_normalized_name || '')
    ## tenant
    csv_item.push('')

    ## [brand]
    csv_item.push(data_row[:product].get_normalized_brand || '')

    ## [category]
    csv_item.push(data_row[:category].imaging_category)

    ## [gender]
    csv_item.push(Category.bb_gender(data_row[:category].id))

    ## [store_id]
    csv_item.push(data_row[:store_id])

    ## [keywords]
    csv_item.push('')

    ## [available]
    csv_item.push(to_availability(data_row))
  end

end