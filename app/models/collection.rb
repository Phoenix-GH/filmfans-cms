class Collection < ActiveRecord::Base
  has_many :collection_contents, dependent: :destroy
  has_many :products_containers, through: :collection_contents, source: :content, source_type: 'ProductsContainer'
  has_many :media_containers, through: :collection_contents, source: :content, source_type: 'MediaContainer'

  has_many :linked_collections, dependent: :destroy
  has_many :collections_containers, through: :linked_collections

  belongs_to :admin

  # THIS METHOD AND COLUMN NEEDS TO BE REMOVED AFTER CreateCollectionBackgroundImages & CreateCollectionCoverImages migrations are run
  mount_uploader :photo, PictureUploader

  has_one :cover_image, class_name: 'CollectionCoverImage', dependent: :destroy
  has_one :background_image, class_name: 'CollectionBackgroundImage', dependent: :destroy
  accepts_nested_attributes_for :cover_image
  accepts_nested_attributes_for :background_image

  def cropper_data
    {
      background: background_image&.cropper_data,
      cover: cover_image&.cropper_data,
      update_url: "/panel/collections/#{id}/update_images",
      cropper_type: 'collection',
      id: "#{self.class.name}_#{id}"
    }
  end

  def products_count
    products_containers.inject(0) do |sum, container|
      sum += container.products.count
    end
  end

  def cover_image_url
    cover_image&.custom_url
  end
end
