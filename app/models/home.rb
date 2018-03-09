class Home < ActiveRecord::Base
  #man: 0, woman: 1, celebrities: 5
  enum home_type: { trending: 2, now_showing: 3, up_coming: 4, merchandise: 6 }

  has_many :home_contents, dependent: :destroy
  has_many :products_containers,
    through: :home_contents,
    source: :content,
    source_type: 'ProductsContainer'
  has_many :collections_containers,
    through: :home_contents,
    source: :content,
    source_type: 'CollectionsContainer'
  has_many :media_containers,
    through: :home_contents,
    source: :content,
    source_type: 'MediaContainer'
  has_many :single_product_containers,
    through: :home_contents,
    source: :content,
    source_type: 'Product'

  scope :published, -> { where(published: true) }

  def products_count
    products_containers.inject(0) do |sum, container|
      sum += container.products.count
    end
  end
end
