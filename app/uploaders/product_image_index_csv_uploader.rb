class ProductImageIndexCsvUploader < CarrierWave::Uploader::Base
  def store_dir
    "uploads/product_image_index/#{model.id}/csv_exports"
  end

end
