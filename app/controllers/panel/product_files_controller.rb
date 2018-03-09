class Panel::ProductFilesController < Panel::BaseController
  before_action :set_product_file, only: [:edit, :update, :destroy]
  before_action :set_product, only: [:new, :create, :edit, :update, :destroy]

  def new
    authorize! :update, @product
    @form = Panel::CreateProductFileForm.new
  end

  def create
    authorize! :update, @product
    @form = Panel::CreateProductFileForm.new(product_file_form_params)
    service = Panel::CreateProductFileService.new(product: @product, form: @form)

    if service.call
      redirect_to panel_product_path(@product), notice: _('Product File was successfully created.')
    else
      render :new
    end
  end

  def edit
    authorize! :update, @product
    @form = Panel::UpdateProductFileForm.new(product_file_attributes)
  end

  def update
    authorize! :update, @product
    @form = Panel::UpdateProductFileForm.new(
      product_file_attributes,
      product_file_form_params
    )
    service = Panel::UpdateProductFileService.new(@product_file, @form)

    if service.call
      redirect_to panel_product_path(@product), notice: _('Product File was successfully updated.')
    else
      render :edit
    end
  end

  def destroy
    authorize! :update, @product
    service = Panel::DestroyProductFileService.new(@product_file)

    if service.call
      flash.notice = _('Product File was successfully deleted.')
    else
      flash.alert = _('Product File not deleted.')
    end

    redirect_to panel_product_path(@product)
  end

  private
  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_product_file
    @product_file = ProductFile.find(params[:id])
  end

  def product_file_attributes
    @product_file.slice('cover_image', 'file')
  end

  def product_file_form_params
    if params[:product_file_form]
      params.require(:product_file_form).permit(:cover_image, :file)
    else
      {}
    end
  end
end
