class Panel::HomesController < Panel::BaseController
  before_action :set_home, only: [:show, :edit, :update, :destroy, :sort, :publish, :unpublish]
  before_action :set_presenter, only: [:edit, :update]

  def index
    authorize! :read, Home
    @homes = HomeQuery.new(home_search_params).results
  end

  def show
    authorize! :read, @home
  end

  def new
    authorize! :create, Home
    @form =  Panel::CreateHomeForm.new
  end

  def create
    authorize! :create, Home
    @form = Panel::CreateHomeForm.new(home_form_params)
    service = Panel::CreateHomeService.new(@form)

    if service.call
      redirect_to edit_panel_home_path(service.home, step: :home_contents),
        notice: _('Home was successfully created.')
    else
      render :new
    end
  end

  def edit
    authorize! :update, @home

    step = params['step'] || 'edit'

    if step == 'edit'
      @form = Panel::UpdateHomeForm.new(home_attributes)
      render :edit
    elsif step == 'home_contents'
      @form = Panel::UpdateHomeContentsForm.new(home_contents_attributes)
      render :home_contents
    end
  end

  def update
    authorize! :update, @home

    step = params['step'] || 'update'
    if step == 'update'
      @form = Panel::UpdateHomeForm.new(
        home_attributes,
        home_form_params
      )
      service = Panel::UpdateHomeService.new(@home, @form)

      if service.call
        redirect_to edit_panel_home_path(@home, step: :home_contents),
        notice: _('Home was successfully updated.')
      else
        render :edit
      end
    elsif step == 'home_contents'
      @form = Panel::UpdateHomeContentsForm.new(
        home_contents_attributes,
        home_contents_form_params
      )

      service = Panel::UpdateHomeContentsService.new(@home, @form)

      if service.call
        redirect_to panel_homes_path,
          notice: _('Home was successfully created.')
      else
        render :home_contents
      end
    else
      redirect_to panel_homes_path
    end

  end

  def destroy
    authorize! :destroy, @home
    @home.destroy

    redirect_to panel_homes_path, notice: _('Home was successfully deleted.')
  end

  def sort
    authorize! :update, @home
    service = Panel::SortHomeContentsService.new(@home, sort_params)
    service.call
    render nothing: true
  end

  def publish
    authorize! :update, @home
    service = Panel::PublishHomeService.new(@home)
    if service.call
      prepare_referrer_params
      redirect_to panel_homes_path(@referrer_params), notice: _('Home was successfully published.')
    else
      render :index, alert: _('Error occured while publishing.')
    end
  end

  def unpublish
    authorize! :update, @home
    service = Panel::UnpublishHomeService.new(@home)
    if service.call
      prepare_referrer_params
      redirect_to panel_homes_path(@referrer_params), notice: _('Home was successfully unpublished.')
    else
      render :index, alert: _('Error occured while unpublishing.')
    end
  end

  private
  def set_home
    @home = Home.find(params[:id])
  end

  def set_presenter
    @presenter = HomePresenter.new(@home)
  end

  def home_search_params
    params.permit(:sort, :direction, :search, :home_type)
  end

  def sort_params
    params.require(:order)
  end

  def home_attributes
    @home.slice('id', 'name', 'home_type')
  end

  def home_contents_attributes
    { home_contents: @home.home_contents.order(:position)
      .select(:id, :content_type, :content_id, :position, :width)
    }
  end

  def home_contents_form_params
    params.require(:home_form).permit(
      home_contents_attributes:
      [:content_type, :content_id, :_destroy, :id, :position, :width]
    )
  end

  def home_form_params
    params.require(:home_form).permit(:home_contents, :name, :home_type)
  end

  def sort_column
    ['name', 'created_at', 'published', 'home_contents', 'products'].include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def prepare_referrer_params
    url = request.referrer
    uri = URI.parse(url)
    @referrer_params = Rack::Utils.parse_nested_query(uri.query)
  end
end
