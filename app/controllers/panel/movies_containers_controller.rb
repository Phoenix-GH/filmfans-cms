class Panel::MoviesContainersController < Panel::BaseController
  before_action :set_movies_container, only: [:show, :edit, :update, :destroy, :sort]
  before_action :set_reserved_container_names, only: [:index, :destroy]

  def index
    authorize! :read, MoviesContainer
    @movies_containers = MoviesContainerQuery.new(movies_container_search_params).results
  end

  #
  # def show
  #   authorize! :read, @movies_container
  #   @movies = @movies_container.movies.order("position ASC")
  # end
  #
  def new
    authorize! :create, MoviesContainer
    @form = Panel::CreateMoviesContainerForm.new
  end

  def create
    authorize! :create, MoviesContainer
    @form = Panel::CreateMoviesContainerForm.new(movies_container_form_params)
    service = Panel::CreateMoviesContainerService.new(@form, current_user)

    if service.call
      redirect_to panel_movies_containers_path, notice: _('Container was successfully created.')
    else
      render :new
    end
  end

  def edit
    authorize! :update, @movies_container
    @form = Panel::UpdateMoviesContainerForm.new(movies_container_attributes)
  end

  def update
    authorize! :update, @movies_container
    @form = Panel::UpdateMoviesContainerForm.new(
        movies_container_attributes,
        movies_container_form_params
    )
    service = Panel::UpdateMoviesContainerService.new(@movies_container, @form)

    if service.call
      redirect_to panel_movies_containers_path, notice: _('Movies Container was successfully updated.')
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @movies_container

    if @reserved_containers.include?(@movies_container.name.downcase)

      redirect_to panel_movies_containers_path, error: _('This is the reserved Movies Container. You cannot delete it')
      return
    end

    Panel::DestroyMoviesContainerService.new(@movies_container).call

    redirect_to panel_movies_containers_path, notice: _('Movies Container was successfully deleted.')
  end

  # def sort
  #   authorize! :update, @movies_container
  #   service = Panel::SortMoviesContainerService.new(@movies_container, sort_params)
  #   service.call
  #   render nothing: true
  # end

  private

  def set_reserved_container_names
    @reserved_containers = ['now showing', 'up coming', 'popular']
  end

  def set_movies_container
    @movies_container = MoviesContainer.find(params[:id])
  end

  def movies_container_search_params
    params.permit(:sort, :direction, :search).merge(admin_id: current_admin.id)
  end
  #
  # def sort_params
  #   params.require(:order)
  # end

  def movies_container_attributes
    @movies_container.slice(
      'id', 'name'
    ).merge(linked_movies: @movies_container.linked_movies.select(:id, :movie_id, :position))
  end

  def movies_container_form_params
    params.fetch(:movies_container_form, {}).permit(
      :name, linked_movies_attributes: [:id, :movie_id, :position]
    )
  end

  def sort_column
    ['created_at', 'name', 'movies'].include?(params[:sort]) ? params[:sort] : 'created_at'
  end
end
