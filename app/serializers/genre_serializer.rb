class GenreSerializer
  def initialize(genre)
    @genre = genre
  end

  def results
    return {} unless @genre
    generate_genre_json
    @genre_json
  end

  private
  def generate_genre_json
    @genre_json = {
      id: @genre.id.to_i,
      name: @genre.name.to_s
    }
  end
end
