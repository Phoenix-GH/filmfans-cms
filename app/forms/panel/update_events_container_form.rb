class Panel::UpdateEventsContainerForm
  include ActiveModel::Model

  attr_accessor(
    :id, :name, :linked_events
  )

  def initialize(events_container_attrs, form_attributes = {})
    super events_container_attrs.merge(form_attributes)
  end

  validates :name, presence: true
  validate :at_least_one_linked_event

  def events_container_attributes
    {
      name: name
    }
  end

  def linked_events_attributes=(attributes)
    @linked_events = set_linked_events(attributes)
  end

  def self.association(association, klass)
    @@attributes ||= {}
    @@attributes[association] = klass
  end

  def self.reflect_on_association(association)
    data = { klass: @@attributes[association] }
    OpenStruct.new data
  end

  association :linked_events, LinkedEvent

  private

  def set_linked_events(attributes)
    attributes.map do |i, params|
      LinkedEvent.new(params)
    end.compact
  end

  def at_least_one_linked_event
    if linked_events.blank?
      errors[:linked_events] << '- at least one must be present'
    end
  end
end
