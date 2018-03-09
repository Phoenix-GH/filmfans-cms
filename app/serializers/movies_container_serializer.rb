class MoviesContainerSerializer
  def initialize(movies_container)
    @movies_container = movies_container
  end

  def results
    return '' unless @movies_container
    generate_movies_container_json

    @movies_container_json
  end

  private

  def generate_movies_container_json
    @movies_container_json = {
      type: 'movies_container',
      id: @movies_container.id,
      channel_id: @movies_container&.channel&.id.to_i,
      name: @movies_container.name.to_s,
      movies: products_json
    }
  end

  def products_json
    @movies_container.linked_movies.order(:position).map do |linked_movie|
      MovieSerializer.new( linked_movie.movie).results.merge(movie_position: linked_movie.position)
    end
  end
end
