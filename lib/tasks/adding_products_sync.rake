task :adding_products_sync, [:dir] => :environment do |t, args|
  if args.dir.blank? or !Dir.exist?(args.dir)
    puts "please add correct directory: rake adding_products['/home/ubuntu/product']"
  else
    Dir.glob("#{args.dir}/*.json") do |json_file|
    	puts "Processing #{json_file}"
      products = File.read(json_file)
      json = ActiveSupport::JSON.decode(products)
      AddProductsFromPromptcloudJson.new(json).call
      File.rename(json_file, json_file.gsub('.json', '_done.json'))
    end
    puts 'done'
  end
end
