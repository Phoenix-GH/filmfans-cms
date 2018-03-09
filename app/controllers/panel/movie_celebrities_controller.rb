class Panel::MovieCelebritiesController < Panel::BaseController
  before_action :set_movie_celebrity, only: [:edit, :update]

  def index
    @entries = MovieCelebrityMappingQuery.new(index_params.merge({sort: sort_column, direction: sort_direction})).results
    set_instagram_statuses
    @instagram_status = [
        ['Not yet processed', 'not-yet-processed'],
        ['Has Instagram', 'has-instagram-followed'],
    ] + @instagram_status
  end

  def edit
    authorize! :update, @movie_celebrity
    @form = Panel::UpdateMovieCelebrityMappingForm.new(movie_celebrity_attributes)
  end

  def update
    authorize! :update, @movie_celebrity

    @form = Panel::UpdateMovieCelebrityMappingForm.new(
        movie_celebrity_attributes,
        movie_celebrity_form_params
    )
    service = Panel::UpdateMovieCelebrityMappingService.new(@movie_celebrity, @form)

    if service.call
      redirect_to panel_movie_celebrities_path, notice: _('The information was successfully updated.')
    else
      render :edit
    end
  end

  private

  def movie_celebrity_attributes
    att = @movie_celebrity.slice('id', 'name', 'instagram_status')

    instagram_url = nil
    unless @movie_celebrity.instagram_id.blank?
      instagram_url = "https://www.instagram.com/#{@movie_celebrity.instagram_id}"
    end
    att.merge({instagram_url: instagram_url})
  end

  def movie_celebrity_form_params
    params.require(:movie_celebrities_form).permit(:id, :name, :instagram_url, :instagram_status)
  end

  def set_movie_celebrity
    @movie_celebrity = MovieCelebrityMapping.find(params[:id])
    set_instagram_statuses
  end

  def set_instagram_statuses
    @instagram_status = [
        ['Not yet followed', MovieCelebrityMapping::INSTAGRAM_STATUS_NOT_FOLLOWED],
        ['No Instagram account found', MovieCelebrityMapping::INSTAGRAM_STATUS_NO_ACCOUNT],
    ]
  end

  def index_params
    params.permit(
        :name, :instagram_status, :page, :per
    )
  end

  def sort_column
    ['name', 'instagram'].include?(params[:sort]) ? params[:sort] : 'name'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end