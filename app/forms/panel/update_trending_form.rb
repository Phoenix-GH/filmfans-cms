class Panel::UpdateTrendingForm
  include ActiveModel::Model

  attr_accessor(
    :trending_contents
  )

  def initialize(trending_attrs, form_attributes = {})
    @attributes = trending_attrs.merge(form_attributes)
    super @attributes
  end

  def trending_contents_attributes=(attributes)
    @trending_contents = set_trending_contents(attributes)
  end

  def self.association(association, klass)
    @@attributes ||= {}
    @@attributes[association] = klass
  end

  def self.reflect_on_association(association)
    data = { klass: @@attributes[association] }
    OpenStruct.new data
  end

  association :trending_contents, TrendingContent

  private
  def set_trending_contents(attributes)
    attributes.map do |i, params|
      TrendingContent.new(params.except(:_destroy)) if params[:_destroy] == 'false'
    end.compact
  end
end
