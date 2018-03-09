class Panel::ThreedModelsController < Panel::BaseController
  before_action :set_threed_ar
  before_action :set_threed_model, only: [:edit, :update, :destroy]
  before_action :set_presenter, only: [:new, :create, :update, :edit]

  def index
    @models = ThreedModelQuery.new(threed_model_search_params).results
  end

  def new
    authorize! :create, ThreedAr
    @form = Panel::CreateThreedModelForm.new({}, {})
  end

  def create
    authorize! :create, ThreedAr

    @form = Panel::CreateThreedModelForm.new({}, threed_model_form_params.merge(threed_ar_id: @threed_ar.id))
    service = Panel::CreateThreedModelService.new(@form)

    @threed_model = service.call
    if @threed_model
      product_service = Panel::UpdateThreedModelProductsService.new(@threed_model, @form)
      if product_service.call
        redirect_to panel_threed_ar_threed_models_path(@threed_ar),
                    notice: _('3D model was successfully created.')
        return
      end
    end
    render :new, notice: _('3D model was not created')
  end

  def edit
    authorize! :edit, @threed_model.threed_ar
    @form = Panel::UpdateThreedModelForm.new(threed_model_params, {})
  end

  def update
    authorize! :edit, @threed_model.threed_ar
    @form = Panel::UpdateThreedModelForm.new(threed_model_params, threed_model_form_params.merge(threed_ar_id: @threed_ar.id))

    service = Panel::UpdateThreedModelService.new(@threed_model, @form)
    product_service = Panel::UpdateThreedModelProductsService.new(@threed_model, @form)

    if service.call
      if product_service.call
        redirect_to panel_threed_ar_threed_models_path(@threed_ar),
                    notice: _('3D model was successfully updated.')
        return
      end
    end

    render :edit, notice: _('3D model was not updated')
  end

  def destroy
    authorize! :destroy, @threed_model.threed_ar
    @threed_model.destroy

    redirect_to panel_threed_ar_threed_models_path, notice: _('3D model was successfully deleted.')
  end

  private

  def set_presenter
    @presenter = ProductsPresenter.new
  end

  def set_threed_ar
    @threed_ar = ThreedAr.find(params[:threed_ar_id])
  end

  def set_threed_model
    @threed_model = ThreedModel.find(params[:id])
  end

  def sort_column
    ['description', 'file'].include?(params[:sort]) ? params[:sort] : 'id'
  end

  def threed_model_search_params
    params.permit(:sort, :direction, :search, :threed_ar_id, :page)
  end

  def threed_model_form_params
    params.require(:threed_model_form).permit(
        :description,
        :file,
        :page,
        threed_model_products_attributes: [:id, :product_id, :position, :_destroy])
  end

  def threed_model_params
    @threed_model.slice(:description, :file, :id).merge(threed_model_products: @threed_model.threed_model_products.select(:id, :product_id, :position))
  end

end
