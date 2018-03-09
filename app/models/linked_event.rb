class LinkedEvent < ActiveRecord::Base
  belongs_to :event
  belongs_to :events_container

  default_scope { order('position') }
end
