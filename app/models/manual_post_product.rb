class ManualPostProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :manual_post
end