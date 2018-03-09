class VariantStore < ActiveRecord::Base
  belongs_to :variant
  belongs_to :store
end
