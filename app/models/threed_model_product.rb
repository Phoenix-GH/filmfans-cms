class ThreedModelProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :threed_model
end