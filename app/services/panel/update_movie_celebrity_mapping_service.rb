class Panel::UpdateMovieCelebrityMappingService
  def initialize(movie_celebrity, form)
    @movie_celebrity = movie_celebrity
    @form = form
  end

  def call
    return false unless @form.valid?

    update_movie_celebrity
  end

  private

  def update_movie_celebrity
    @movie_celebrity.update_attributes(@form.movie_celebrity_attributes)
  end

end