class ProductImageCSVExport < ActiveRecord::Base
  mount_uploader :delta_add_file, ProductImageIndexCsvUploader
  mount_uploader :delta_remove_file, ProductImageIndexCsvUploader
end
