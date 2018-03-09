class Panel::UpdateMoviesContainerService
  def initialize(movies_container, form)
    @movies_container = movies_container
    @form = form
  end

  def call
    return false unless @form.valid?

    update_movies_container
    add_linked_movies
  end

  def products_container
    @movies_container
  end

  private

  def update_movies_container
    @movies_container.update_attributes(@form.movies_container_attributes)
  end

  def add_linked_movies
    Panel::CreateLinkedMovieService.new(@movies_container, @form.linked_movies).call
  end

end
