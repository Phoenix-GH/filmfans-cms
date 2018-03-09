class Panel::MoviesController < Panel::BaseController

  before_action :set_movie, only: [:show, :edit, :update, :destroy, :update_images, :products, :update_products]

  def index
    authorize! :read, Movie
    @movies = MovieQuery.new(movie_search_params).results
  end

  def destroy
    authorize! :destroy, @movie
    @movie.destroy

    redirect_to panel_movies_path, notice: _('Movie was successfully deleted.')
  end

  def gracenote_search
    return if g_params[:search].blank?

    @gracenote_search_rs = gracenote_service.search_movies(g_params[:search], g_params[:page] || 0, g_params[:per] || 25)

    movies = @gracenote_search_rs[:movies]
    ids = movies.map { |m| m[:id] }

    @imported_ids = Movie.select(:gracenote_id).where(gracenote_id: ids).map { |m| m.gracenote_id }

    @gracenote_search_total = @gracenote_search_rs[:total]
    @gracenote_movies = Kaminari.paginate_array(movies, total_count: @gracenote_search_total)
                            .page(g_params[:page] || 0)
                            .per(g_params[:per] || 25)
    @gracenote_keyword = g_params[:search]
    @gracenote_page = g_params[:page]
    @gracenote_per = g_params[:per]
  end

  def import_gracenote_movie
    i_params = import_gracenote_params

    Panel::ImportGracenoteMovieService.new(i_params[:gracenote_id], request.remote_ip).call

    redirect_to gracenote_search_panel_movies_path(search: i_params[:search],
                                                   page: i_params[:page],
                                                   per: i_params[:per]), notice: _('Movie was successfully imported.')
  end

  def products
    @presenter = ProductsPresenter.new
    @form = Panel::UpdateMovieProductForm.new(movie_product_attributes)
  end

  def update_products
    @presenter = ProductsPresenter.new
    @form = Panel::UpdateMovieProductForm.new(
        movie_product_attributes,
        movie_product_form_params
    )
    service = Panel::UpdateMovieProductsService.new(@movie, @form)
    if service.call
      redirect_to products_panel_movie_path(@movie),
                  notice: _('Linked products were successfully updated.')
    else
      render :products
    end
  end

  private

  def gracenote_service
    @gracenote_service ||= Movie::GracenoteMovieService.new(request.remote_ip)
  end

  def sort_column
    ['created_at', 'title', 'ratings_imdb_value', 'ratings_tmdb_value', 'runtime'].include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def set_movie
    @movie = Movie.find(params[:id])
  end

  def movie_search_params
    params.permit(:sort, :direction, :search, :page, :genre_id).merge(admin_id: current_admin.id)
  end

  def g_params
    params.permit(:search, :page, :per)
  end

  def import_gracenote_params
    params.permit(:search, :page, :per, :gracenote_id)
  end

  def movie_product_attributes
    @movie.slice(
        'id'
    ).merge(movie_products: @movie.movie_products.select(:id, :product_id, :position))
  end

  def movie_product_form_params
    params.fetch(:movie_products_form, {}).permit(
        movie_products_attributes: [:id, :product_id, :position, :_destroy]
    )
  end

end
