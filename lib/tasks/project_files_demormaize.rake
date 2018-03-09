task :project_files_denormalize, [:start_id, :finish_id] => :environment do |t, args|

  products = Product.includes(:product_files).order(:id)
  products = products.where('id >= ?', args.start_id) unless args.start_id.blank?
  products = products.where('id <= ?', args.finish_id) unless args.finish_id.blank?

  products.find_in_batches(batch_size: 10000) do |group|
    puts "processing group staring with product_id: #{group.first.id} at #{Time.current}" if group.first.present?
    group.each do|p|
      p.update_column(
          :product_files,
          p.product_files.map do |pf|
            {
                small_version_url:  pf.small_version_url,
                normal_version_url: pf.normal_version_url,
                large_version_url:  pf.normal_version_url
            }
          end
      )
      p.save!
    end
  end
end

task :variant_files_denormalize, [:start_id, :finish_id] =>  :environment do |t, args|

  variants = Variant.includes(:variant_files).order(:id)
  variants = variants.where('id >= ?', args.start_id) unless args.start_id.blank?
  variants = variants.where('id <= ?', args.finish_id) unless args.finish_id.blank?

  variants.includes(:variant_files).find_in_batches(batch_size: 10000) do |group|
    puts "processing group staring with variant_id: #{group.first.id} at #{Time.current}" if group.first.present?
    group.each do|p|
      p.update_column(
          :variant_files,
          p.variant_files.map do |pf|
            {
                small_version_url:  pf.small_version_url,
                normal_version_url: pf.normal_version_url,
                large_version_url:  pf.normal_version_url
            }
          end
      )
      p.save!
    end
  end

end

