class Tag < ActiveRecord::Base
  belongs_to :media_container
  belongs_to :product
end
