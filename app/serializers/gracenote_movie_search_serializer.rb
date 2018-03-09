class GracenoteMovieSearchSerializer
  def initialize(movie)
    @movie = movie
  end

  def results
    {
        id: "#{@movie['rootId']}@#{@movie['tmsId']}",
        title: @movie['title'],
        synopsist: @movie['longDescription'],
        genres: @movie['genres'],
        image_url: GracenoteMoveDetailSerializer::image_url(@movie),
        poster_thumbnail: GracenoteMoveDetailSerializer::image_url(@movie),
    }
  end
end