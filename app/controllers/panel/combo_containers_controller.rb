class Panel::ComboContainersController < Panel::BaseController
  before_action :set_products_container, only: [:show, :edit, :update, :destroy, :sort]
  before_action :set_presenter, only: [:new, :create, :edit, :update]

  def index
    @products_containers = ProductsContainerQuery.new(products_container_search_params).results
  end

  def show
    authorize! :read, @products_container
    @products = @products_container.products.order("position ASC")
  end

  def new
    authorize! :create, ProductsContainer
    @form =  Panel::CreateProductsContainerComboForm.new
  end

  def create
    authorize! :create, ProductsContainer
    @form = Panel::CreateProductsContainerComboForm.new(products_container_form_params)
    service = Panel::CreateProductsContainerComboService.new(@form)

    if service.call
      redirect_to panel_combo_containers_path, notice: _('Combo Container was successfully created.')
    else
      set_cover_image_params(@form.media_content)
      render :new
    end
  end

  def edit
    authorize! :update, @products_container
    @form = Panel::UpdateProductsContainerComboForm.new(products_container_attributes)
    set_cover_image_params(@products_container.media_content)
  end

  def update
    authorize! :update, @products_container
    @form = Panel::UpdateProductsContainerComboForm.new(
      products_container_attributes,
      products_container_form_params
    )
    service = Panel::UpdateProductsContainerComboService.new(@products_container, @form)

    if service.call
      redirect_to panel_combo_containers_path, notice: _('Combo Container was successfully updated.')
    else
      set_cover_image_params(@form.media_content)
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @products_container
    @products_container.destroy

    redirect_to panel_combo_containers_path, notice: _('Combo Container was successfully deleted.')
  end

  def sort
    authorize! :update, @products_container
    service = Panel::SortProductsContainerService.new(@products_container, sort_params)
    service.call
    render nothing: true
  end

  private

  def set_products_container
    @products_container = ProductsContainer.find(params[:id])
  end

  def products_container_search_params
    params.permit(:sort, :direction, :search)
      .merge(with_media_owner: true)
      .merge(channel_ids: current_admin.channel_ids)
      .merge(media_owner_ids: current_admin.media_owner_ids)
  end

  def sort_params
    params.require(:order)
  end

  def products_container_attributes
    @products_container.slice(
      'id', 'name', 'media_owner_id', 'description', 'channel_id'
    )
  end

  def products_container_form_params
    params.require(:products_container_form).permit(
      :name, :description, :product_ids, :media_content_id, :media_owner_id, :channel_id
    )
  end


  def set_cover_image_params(content)
    return if content.nil?

    @image_params = {
      id: content.id,
      name: File.basename(content.file.url),
      size: content.file.size,
      src: content.cover_image.small_thumb.url
    }
  end

  def set_presenter
    @presenter = AdminPresenter.new(current_admin)
  end

  def sort_column
    ['created_at', 'name', 'media_owners.name'].include?(params[:sort]) ? params[:sort] : 'name'
  end
end
