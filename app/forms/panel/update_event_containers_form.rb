class Panel::UpdateEventContainersForm
  include ActiveModel::Model

  attr_accessor(
    :event_contents
  )

  def initialize(event_attrs, form_attributes = {})
    @attributes = event_attrs.merge(form_attributes)
    super @attributes
  end

  def event_contents_attributes=(attributes)
    @event_contents = set_event_contents(attributes)
  end

  def self.association(association, klass)
    @@attributes ||= {}
    @@attributes[association] = klass
  end

  def self.reflect_on_association(association)
    data = { klass: @@attributes[association] }
    OpenStruct.new data
  end

  association :event_contents, EventContent

  private
  def set_event_contents(attributes)
    attributes.map do |i, params|
      EventContent.new(params.except(:_destroy)) if params[:_destroy] == 'false'
    end.compact
  end

end
