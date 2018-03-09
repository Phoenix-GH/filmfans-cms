class AddProductsFromPromptcloudJsonWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :prompcloud_import

  def perform(json_file)
    products = File.read(json_file)
    json = ActiveSupport::JSON.decode(products)

    AddProductsFromPromptcloudJson.new(json).call
    File.rename(json_file, json_file.gsub('.json', '_done.json'))
  end
end
