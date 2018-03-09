class Panel::ProductsController < Panel::BaseController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :toggle_container_active,
                                     :load_categories, :update_categories, :view_product_detail]

  def index
    @presenter = ProductsPresenter.new
    @products = ProductQuery.new(products_search_params).results
  end

  def table
    @products = ProductQuery.new(products_search_params).results
    render partial: 'table', layout: false
  end

  def show
  end

  def new
    authorize! :create, Product
    @presenter = ProductsPresenter.new
    @form = Panel::Wizards::CreateProductForm.new
    render :product_new
  end

  def create
    authorize! :create, Product
    @presenter = ProductsPresenter.new
    @form = Panel::Wizards::CreateProductForm.new(product_form_params)
    service = Panel::Wizards::CreateProductService.new(@form)
    if service.call
      redirect_to edit_panel_product_path(service.product.id, step: :variants)
    else
      render :product_new
    end
  end

  def edit
    authorize! :update, @product
    step = params['step'] || 'product'
    @presenter = ProductsPresenter.new
    if step == 'product'
      @form = Panel::Wizards::UpdateProductForm.new(product_attributes)
      render :product_edit
    elsif step == 'variants'
      @form = Panel::Wizards::EditProductVariantsForm.new(@product)
      render :variants
    elsif step == 'similars'
      @form = Panel::Wizards::UpdateProductSimilarsForm.new(similar_products_attributes)
      render :similars
    end
  end

  def view_product_detail
    respond_to do |format|
      format.html do
        render :product_detail_modal, layout: false
      end
    end
  end

  def update
    authorize! :update, @product
    @presenter = ProductsPresenter.new
    step = params['step'] || 'product'
    if step == 'product'
      @form = Panel::Wizards::UpdateProductForm.new(
          product_attributes,
          product_form_params
      )
      service = Panel::Wizards::UpdateProductService.new(@product, @form)
      if service.call
        redirect_to edit_panel_product_path(@product, step: :variants)
      else
        render :product_edit
      end
    elsif step == 'variants'
      @form = Panel::Wizards::UpdateProductVariantsForm.new(
          variants_attributes,
          variants_form_params
      )

      service = Panel::Wizards::UpdateProductVariantsService.new(@product, @form)

      if service.call
        redirect_to edit_panel_product_path(@product, step: :similars)
      else
        render :variants
      end
    elsif step == 'similars'
      @form = Panel::Wizards::UpdateProductSimilarsForm.new(
          similar_products_attributes,
          similar_products_form_params
      )
      service = Panel::Wizards::UpdateProductSimilarsService.new(@product, @form)

      if service.call
        redirect_to panel_products_path(@product)
      else
        render :similars
      end
    else
      redirect_to panel_products_path
    end
  end

  def destroy
    authorize! :destroy, @product
    service = Panel::DestroyProductService.new(@product)
    if service.call
      redirect_to :back, notice: _('Product was successfully deleted.')
    else
      redirect_to [:panel, @product], alert: _('Product not deleted.')
    end
  end


  def toggle_container_active
    authorize! :update, @product

    service = Panel::ToggleService.new(@product, :containers_placement)
    service.call

    respond_to do |format|
      format.js do
        render layout: false
      end
    end
  end

  def load_categories
    main_categories = ProductsPresenter.new.category_main_options

    @selected_category_ids = @product.categories.map { |category| category.id }.to_set
    @selected_category_name = @product.categories.map { |category| category.full_name }.to_set

    @available_categories = []
    main_categories.each do |top_parent|
      top_parent.subcategories.each do |category|
        @available_categories << {id: category.id, name: category.name}
      end
    end

    respond_to do |format|
      format.html do
        render :category_modal, layout: false
      end
    end
  end

  def update_categories
    Panel::Wizards::CreateProductCategoryService.new(@product, params[:selected_category_ids]).call
    @product = @product.reload
    respond_to do |format|
      format.html do
        render :product_categories, layout: false
      end
    end
  end

  private
  def set_product
    @product = Product.find(params[:id])
    @similarProduct = @product.get_similarity.map { |product|
      Json::ProductsController::serialize_one_product product
    }
  end

  def products_search_params
    params.permit(:sort, :direction, :search, :brand_search, :category_id, :store_id, :brand, :page, :vendor, :available)
  end

  def product_attributes
    @product
        .slice('brand', 'name', 'vendor_url', 'shipping_info', 'category_ids', 'id', 'containers_placement')
  end

  def variants_attributes
    {}
  end

  def variants_form_params
    params.fetch(:product_form, {}).permit(
        variants_attributes: [:color, :description, :position, :_destroy, :temp_image_ids, sizes_attributes: [:size, :price, :_destroy]]
    )
  end

  def similar_products_attributes
    @product.slice(
        'id'
    ).merge(similar_products: @product.product_similarity.select(:id, :product_to_id))
  end

  def product_form_params
    params.require(:product_form).permit(
        :brand,
        :name,
        :step,
        :shipping_info,
        :vendor_url,
        :containers_placement,
        category_ids: []
    )
  end

  def similar_products_form_params
    params.fetch(:similar_products_form, {}).permit(
        similar_products_attributes: [:id, :product_to_id, :_destroy]
    )
  end

  def sort_column
    ['brand', 'name', 'created_at'].include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : (sort_column == 'created_at' ? 'desc' : 'asc')
  end
end
