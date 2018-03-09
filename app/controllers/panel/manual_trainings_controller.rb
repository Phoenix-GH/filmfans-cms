require 'csv'

class Panel::ManualTrainingsController < Panel::BaseController
  before_action :set_item, only: [:destroy, :edit, :update, :train_user_image, :delete_train_user_image]

  def index
    @list = ManualTrainingQuery.new(params).results
  end

  def new
    @presenter = ProductsPresenter.new
    @products_form = Panel::ManualTrainingProductForm.new
  end

  def create
    @products_form = Panel::ManualTrainingProductForm.new(
        {},
        manual_training_form_params
    )
    if @products_form.manual_training_products.blank?
      flash[:alert] = 'Must select at least one product'

      @presenter = ProductsPresenter.new
      @products_form = Panel::ManualTrainingProductForm.new

      render :new
    else
      service = Panel::CreateManualTrainingService.new(@products_form)

      manual_training = service.call

      visenze = Panel::ManualTrainVisenzeService.new
      visenze.add_all_to_index(manual_training)

      redirect_to edit_panel_manual_training_path(manual_training), notice: _('Training set was successfully created.')
    end
  end

  def csv
    @list = ManualTrainingQuery.new(params).results
    headers['Content-Disposition'] = "attachment; filename=\"manual-products.csv\""
    render text: to_csv, :content_type => 'text/csv'
  end

  def edit
    prepare_for_edit
  end

  def update
    @products_form = Panel::ManualTrainingProductForm.new(
        manual_training_attributes,
        manual_training_form_params
    )

    # determine removed products
    new_pids = @products_form.manual_training_products.map { |mp| mp.product_id }
    old_pids = @item.manual_training_products.map { |mp| mp.product_id }
    removed_pids = old_pids - new_pids
    puts "removed PIDs #{removed_pids}"

    if @products_form.manual_training_products.blank?
      flash[:alert] = 'Must select at least one product'

      @presenter = ProductsPresenter.new
      render :edit
    else
      service = Panel::UpdateManualTrainingService.new(@item, @products_form)

      visenze = Panel::ManualTrainVisenzeService.new
      visenze.remove_from_index(removed_pids)

      manual_training = service.call

      visenze.add_all_to_index(manual_training)

      redirect_to edit_panel_manual_training_path(manual_training), notice: _('Training set was successfully update.')
    end
  end

  def train_user_image
    if params[:image_url].blank?
      flash[:alert] = 'Image url must be provided'
      prepare_for_edit
      render :edit
      return
    end

    service = Panel::ManuallyTrainUserImageService.new(@item, params[:image_url])
    if service.create
      redirect_to edit_panel_manual_training_path(@item.id),
                  notice: _('The image has been sent to the index server')
    else
      flash[:alert] = 'Cannot send the image to the index server'
      prepare_for_edit
      render :edit
    end
  end

  def delete_train_user_image
    service = Panel::ManuallyTrainUserImageService.new(@item, nil)
    if service.delete(params[:image_id])
      render json: {message: :success}, status: :ok
    else
      render json: {message: :error}, status: :unprocessable_entity
    end
  end

  private

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << %w(im_name im_url category related_ids)
      @list.each do |item|
        item.products.each do |p|
          puts p.id
          csv << [p.id, p.image_display_url, item.category, item.related_ids]
        end
      end
    end
  end

  def set_item
    @item = ManualTraining.find(params[:id])
  end

  def sort_column
    ['name'].include?(params[:sort]) ? params[:sort] : 'name'
  end

  def sort_params
    params.require(:order)
  end

  def prepare_for_edit
    @presenter = ProductsPresenter.new
    @products_form = Panel::ManualTrainingProductForm.new(
        manual_training_attributes,
        {})
  end

  def manual_training_attributes
    @item.slice(
        'id'
    ).merge(manual_training_products: @item.manual_training_products.select(:id, :product_id, :position))
  end

  def manual_training_form_params
    params.fetch(:manual_training_products_form, {}).permit(
        manual_training_products_attributes: [:id, :product_id, :position, :_destroy]
    )
  end

end