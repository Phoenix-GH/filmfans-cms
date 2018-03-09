class Panel::UpdateHomeContentsForm
  include ActiveModel::Model

  attr_accessor(
    :home_contents
  )

  def initialize(home_attrs, form_attributes = {})
    @attributes = home_attrs.merge(form_attributes)
    super @attributes
  end

  def home_contents_attributes=(attributes)
    @home_contents = set_home_contents(attributes)
  end

  def self.association(association, klass)
    @@attributes ||= {}
    @@attributes[association] = klass
  end

  def self.reflect_on_association(association)
    data = { klass: @@attributes[association] }
    OpenStruct.new data
  end

  association :home_contents, HomeContent

  private
  def set_home_contents(attributes)
    attributes.map do |i, params|
      HomeContent.new(params.except(:_destroy)) if params[:_destroy] == 'false'
    end.compact
  end
end
