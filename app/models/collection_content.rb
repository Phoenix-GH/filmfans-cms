class CollectionContent < ActiveRecord::Base
  belongs_to :collection

  belongs_to :content, polymorphic: true
end
