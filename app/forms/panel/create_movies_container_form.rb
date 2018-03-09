class Panel::CreateMoviesContainerForm
  include ActiveModel::Model

  attr_accessor(
    :name, :linked_movies
  )

  validates :name, presence: true
  #validate :at_least_one_linked_movie

  def initialize(attributes = {})
    @attributes = defaults.merge(attributes)
    super(@attributes)
  end

  def movies_container_attributes
    {
      name: name
    }
  end

  def linked_movies_attributes=(attributes)
    @linked_movies = set_linked_movies(attributes)
  end

  def self.association(association, klass)
    @@attributes ||= {}
    @@attributes[association] = klass
  end

  def self.reflect_on_association(association)
    data = { klass: @@attributes[association] }
    OpenStruct.new data
  end

  association :linked_movies, LinkedMovie

  private

  def defaults
    { linked_movies: [] }
  end

  def set_linked_movies(attributes)
    attributes.map do |i, params|
      LinkedMovie.new(params)
    end.compact
  end

  def at_least_one_linked_movie
    if linked_movies.blank?
      errors[:linked_movies] << '- at least one must be present'
    end
  end
end
