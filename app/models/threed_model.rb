class ThreedModel < ActiveRecord::Base
  belongs_to :threed_ar
  has_many :threed_model_products, dependent: :destroy
  has_many :products, through: :threed_model_products

  mount_uploader :image, PictureUploader
  mount_uploader :file, ThreedModelUploader

  scope :having_out_stock_products, -> {
    joins(:products)
        .where(products: {available: false})
        .select("'#{ThreedModel.name}' AS type")
        .select(:id)
  }

  def file_name
    file.file.filename
  end
end