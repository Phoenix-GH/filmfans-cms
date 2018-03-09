class Panel::UpdateMovieProductForm
  include ActiveModel::Model

  attr_accessor(
      :movie_products,
      :id
  )

  def initialize(attributes = {}, form_params = {})
    if attributes.blank?
      super(defaults.merge(form_params))
    else
      super(attributes.merge(form_params))
    end
  end

  def movie_products_attributes=(attributes)
    @movie_products = set_movie_products(attributes)
  end

  def self.association(association, klass)
    @@attributes ||= {}
    @@attributes[association] = klass
  end

  def self.reflect_on_association(association)
    data = {klass: @@attributes[association]}
    OpenStruct.new data
  end

  association :movie_products, MovieProduct

  def set_movie_products(attributes)
    attributes.map do |i, params|
      MovieProduct.new(params.except(:_destroy)) if params[:_destroy] == 'false'
    end.compact
  end

  def defaults
    {movie_products: []}
  end
end