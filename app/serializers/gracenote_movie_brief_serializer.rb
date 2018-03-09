class GracenoteMovieBriefSerializer
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
        id: "#{@movie['rootId']}@#{@movie['tmsId']}",
        title: @movie['title'],
        image_url: GracenoteMoveDetailSerializer::image_url(@movie),
        genres: @movie['genres'],
        year: @movie['releaseYear']
    }
  end

end