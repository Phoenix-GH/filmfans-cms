task :adding_products, [:dir] => :environment do |t, args|
  if args.dir.blank? or !Dir.exist?(args.dir)
    puts "please add correct directory: rake adding_products['/home/ubuntu/product']"
  else
    Dir.glob("#{args.dir}/*.json") do |json_file|
      AddProductsFromPromptcloudJsonWorker.perform_async(json_file)
    end
    puts 'done'
  end
end
