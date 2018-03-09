class Panel::ProductsContainersController < Panel::BaseController
  before_action :set_products_container, only: [:show, :edit, :update, :destroy, :sort]
  before_action :set_presenter, only: [:edit, :update, :new, :create]

  def index
    @presenter = ProductsPresenter.new
    @products_containers = ProductsContainerQuery.new(products_container_search_params).results
  end

  def show
    authorize! :read, @products_container
    @products = @products_container.products.order("position ASC")
  end

  def new
    authorize! :create, ProductsContainer
    @form =  Panel::CreateProductsContainerForm.new
  end

  def create
    authorize! :create, ProductsContainer
    @form = Panel::CreateProductsContainerForm.new(products_container_form_params)
    create_service = Panel::CreateProductsContainerService.new(@form, current_user)

    if create_service.call
      redirect_to panel_products_containers_path, notice: _('Products Container was successfully created.')
    else
      render :new, alert: _('Error occured while saving container.')
    end
  end

  def edit
    authorize! :update, @products_container
    @products = @products_container.products.order("position ASC")
    @form = Panel::UpdateProductsContainerForm.new(products_container_attributes)
  end

  def update
    authorize! :update, @products_container
    @form = Panel::UpdateProductsContainerForm.new(
      products_container_attributes,
      products_container_form_params
    )
    update_service = Panel::UpdateProductsContainerService.new(@products_container, @form)

    if update_service.call
      redirect_to panel_products_containers_path, notice: _('Products Container was successfully updated.')
    else
      @products = update_service.products_container.products.order("position ASC")
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @products_container
    @products_container.destroy

    redirect_to panel_products_containers_path, notice: _('Products Container was successfully deleted.')
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

  def set_presenter
    @presenter = ProductsPresenter.new
  end

  def products_container_search_params
    params.permit(:category_id, :sort, :direction, :search, :page).merge(admin_id: current_admin.id)
  end

  def sort_params
    params.require(:order)
  end

  def products_container_attributes
    @products_container.slice(
      'id', 'name', 'category_id'
    ).merge(linked_products: @products_container.linked_products.select(:id, :product_id, :position))
  end

  def products_container_form_params
    form_params = params.require(:products_container_form).permit(
      name_all_langs: supported_languages, linked_products_attributes: [:id, :product_id, :position, :_destroy]
    )
    form_params.reverse_merge! ({
        category_id: params[:products_container_form][:product_category_id],
        linked_products_attributes: []
    })
  end

  def sort_column
    ['created_at', 'name', 'products'].include?(params[:sort]) ? params[:sort] : 'created_at'
  end
end
