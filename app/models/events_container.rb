class EventsContainer < ActiveRecord::Base
  belongs_to :channel
  belongs_to :admin

  has_many :linked_events, dependent: :destroy
  has_many :events, through: :linked_events

  accepts_nested_attributes_for :linked_events, allow_destroy: true

  def cover_image_url
    events.first&.cover_image_url
  end

  def second_cover_image_url
    events.second&.cover_image_url
  end
end
