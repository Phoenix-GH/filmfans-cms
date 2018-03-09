class Store < ActiveRecord::Base
  has_many :variant_stores
  # expect the following string format in DB:
  #   ["VN", "HK", "US"]
  serialize :country

  validates :name, uniqueness: true

  def self.list_stores_having_products
    Store.order(:name)
  end
end
