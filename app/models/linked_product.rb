class LinkedProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :products_container
end
