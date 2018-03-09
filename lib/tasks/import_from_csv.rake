require 'optparse'
require 'csv'

namespace :import do
  desc 'import products from json'
  task :import_json => :environment  do
    options = {}
    parser = OptionParser.new() do |opts|
      opts.on("-f", "--file ARG", String) { |f| options[:file_path] = f }
    end
    parser.parse!(parser.order!(ARGV) {})

    counter = 0

    #raise 'File must be defined' if options[:file_path].blank?

    options[:file_path] = '/Users/otsarenko/Downloads/task/amazon_com_uniqorn_set1_product_uniqorn_labs_deduped_n-20161008_163518791041499.json'

    file = File.read(options[:file_path])
    data_hash = JSON.parse(file)

    products_array = data_hash['root']['page']


    item = products_array.first['record']

    item['uniq_id']
    item['detail_pageurl']
    item['title']
    item['innermost_category']
    item['department']
    item['product_name']
    item['item_base_price']


    item['category_hierarchy']
    item['available_variants']['size_name']# {'size_name_0' => '2 T'}
    item['available_variants']['color_name']# {'color_name_0' => 'Multi'}
    item['images']['default_image_links']['largeImage']
    item['images']['default_image_links']['mediumImage']
    item['images']['default_image_links']['smallImage']

  end


  desc 'import products from csv'
  task :import_csv => :environment  do
    options = {}
    parser = OptionParser.new() do |opts|
      opts.on("-f", "--file ARG", String) { |f| options[:file_path] = f }
    end
    parser.parse!(parser.order!(ARGV) {})

    counter = 0
    counter_skipped = 0
    create_disney_categories

    store = Store.find_by_name('Disney')
    if store.nil?
      store = Store.create!({:id => Store.maximum(:id).next, :name => 'Disney'})
    end

    raise 'File must be defined' if options[:file_path].blank?

    CSV.foreach(options[:file_path], :row_sep => "\n", :col_sep =>"\t", :headers => :first_row) do |row|
      product = nil

      #ignore product  if  it 'out of stock' or haven't price
      next unless row['availability'] == 'in stock'
      next if row['price'].blank?
      next if row['description'].blank?
      next if row['image_link'].blank?
      next if row['link'].blank?

      product = Product.where("product_code = 'DI-#{row['id']}'")
      if product.present?
        puts "Product already exist"
        counter_skipped += 1
        next
      end

      ActiveRecord::Base.transaction do
        product = Product.create!({
                                      :name => row['title'],
                                      :product_code => "DI-#{row['id']}",
                                      :description => row['description'],
                                      :brand => 'Disney',
                                      :price_range =>  row['sale_price'].blank? ? row['price'] : "#{row['sale_price']} - #{row['price']}",
                                      :vendor_product_image_url => row['image_link'],
                                      :category_hierarchy => [row['product_category_name']],
                                      :vendor_url => row['product_url'],
                                      :product_files => [{"large_version_url": nil, "small_version_url": nil, "normal_version_url": row['image_link']}]

                                  })

        ProductCategory.create!({:category => category_matching(row['product_type'].downcase), :product => product, :manual => false})

        variant = Variant.create!({:product => product, :description => row['description'], :position => 1})
        puts "Variant was created  #{variant.id}"

        VariantStore.create!({
                                 :store => store,
                                 :variant => variant,
                                 :price => Monetize.parse(row['price']).to_f,
                                 :sale_price => row['sale_price'].blank? ? nil : Monetize.parse(row['sale_price']).to_f,
                                 :currency => Monetize.parse(row['price']).currency.to_s,
                                 :url => row['product_url'],
                                 :sku => row['mpn']
                             })

        unless row['size'].blank?
          optionSize = OptionType.where('lower(name) = ?', 'size').first
          raise 'Option Size is not found' if optionSize.nil?

          optionSizeValue = optionSize.option_values.where('lower(name) = ?', row['size'].downcase).first
          if optionSizeValue.nil?

            optionSizeValue = OptionValue.create!({:option_type => optionSize, :name => row['size'].downcase})
            puts "Option Value was created  #{optionSizeValue.id} -  #{optionSizeValue.name}"
          end
          variant.option_values << optionSizeValue
        end

        unless  row['color'].blank?
          optionColor = OptionType.where('lower(name) = ?', 'color').first
          raise 'Option Color is not found' if optionColor.nil?

          optionColorValue = optionColor.option_values.where('lower(name) = ?', row['color'].downcase).first
          if optionColorValue.nil?
            optionColorValue = OptionValue.create!({:option_type => optionColor, :name => row['color']})
            puts "Option Value was created  #{optionColorValue.id} -  #{optionColorValue.name}"
          end
          variant.option_values << optionColorValue
        end
      end

      puts "Successfully added product #{product.id}"
      counter += 1
    end

    puts "Was added #{counter} products"
    puts "Was skipped #{counter_skipped} products"
  end

  def category_matching product_type
    product_type = product_type.split(',').first
    @csv ||= CSV.read("#{Rails.root}/config/category_matching.csv")
    @matching =  {}

    if @matching.blank?
      @csv.each do |row|
        @matching[row[0].downcase.squish.parameterize.underscore] = Category.where('lower(name) = ? AND level = 3', row[1].downcase).first
      end
    end

    category = @matching[product_type.downcase.squish.parameterize.underscore]
    raise "Match category not found ('#{product_type}')" if category.nil?
    category
  end

  def create_disney_categories
    start_id = 1000
    root_category = Category.where('lower(name) = ?', 'Disney store'.downcase).first
    if root_category.nil?
      root_category = Category.create!({:name => 'Disney store',  :level => 1, :id => start_id})
      puts "Root Category was created"
    end

    @csv ||= CSV.read("#{Rails.root}/config/category_matching.csv")
    categories_name = @csv.map{|x| x[1]}.uniq

    categories_name.each do |cat_name|
      start_id += 1
      category_l1 = Category.where('lower(name) = ? AND level = 2 AND parent_id = ?', cat_name.downcase, root_category.id ).first
      category_l1 = Category.create!({:id => start_id, :name => cat_name,  :level => 2, :parent_category => root_category}) if category_l1.nil?

      start_id += 1
      category_l2 = Category.where('lower(name) = ?  AND level = 3 AND parent_id = ?', cat_name.downcase, category_l1.id).first
      category_l2 = Category.create!({:id => start_id, :name => cat_name,  :level => 3, :parent_category => category_l1}) if category_l2.nil?
    end
  end
end


