class MovieSerializer
  def initialize(movie)
    @movie = movie
  end

  def results
    return {} unless @movie
    generate_movie_json

    @movie_json
  end

  private
  def generate_movie_json
    @movie_json = {
      id: @movie.id.to_i,
      title: @movie.title.to_s,
      name: @movie.name.to_s,

      image_url: @movie.poster_image_thumbnail,
      cover_image_url: @movie.poster_image_thumbnail,

      original_title: @movie.original_title,
      synopsist: @movie.synopsist,
      runtime: @movie.runtime,

      ratings_tmdb_value: @movie.ratings_tmdb_value,
      ratings_tmdb_vote_count: @movie.ratings_tmdb_vote_count,

      ratings_imdb_value: @movie.ratings_imdb_value,
      ratings_imdb_vote_count: @movie.ratings_imdb_vote_count,

      website: @movie.website,
      production_companies: @movie.production_companies,

      trailers:  trailers,
      poster: posters,
      scene_images: scene_images,

      actors:  @movie.actors.actors.map{|a| ActorSerializer.new(a).results},

      writers:  @movie.actors.writers.map{|a| ActorSerializer.new(a).results},
      directors:  @movie.actors.directors.map{|a| ActorSerializer.new(a).results},

      genres:  @movie.genres.map{|a| GenreSerializer.new(a).results},
    }
  end

  def trailers
    t = @movie.trailers
    return nil if t.nil?

    t.first['trailer_files'].select{|t| t['format'] == 'mp4'}
  end

  def posters
    @movie.poster_images
  end

  def scene_images
    @movie.scene_images.map{|s| s['image_files'].first}
  end

end
