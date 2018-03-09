class LinkedCollection < ActiveRecord::Base
  belongs_to :collection
  belongs_to :collections_container
end
