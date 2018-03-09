class EventContent < ActiveRecord::Base
  belongs_to :event
  belongs_to :content, polymorphic: true
end
