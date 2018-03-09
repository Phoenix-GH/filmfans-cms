class Panel::CreateMoviesContainerService
  def initialize(form, user)
    @form = form
    @user = user
  end

  def call
    return false unless @form.valid?

    create_movies_container
    add_linked_movies
    add_admin_id
  end

  def movies_container
    @movies_container
  end

  private
  def create_movies_container
    @movies_container = MoviesContainer.create(@form.movies_container_attributes)
  end

  def add_linked_movies
    Panel::CreateLinkedMovieService.new(@movies_container, @form.linked_movies).call
  end

  def add_admin_id
    if @user.role == 'moderator'
      @movies_container.update_attributes(admin_id: @user.id)
    end

    true
  end
end
