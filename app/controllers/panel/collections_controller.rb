class Panel::CollectionsController < Panel::BaseController
  before_action :set_collection, only: [:show, :edit, :update, :destroy, :sort, :update_images]
  before_action :set_presenter, only: [:edit, :update]

  def index
    authorize! :read, Collection
    @collections = CollectionQuery.new(collection_search_params).results
  end

  def show
    authorize! :read, Collection
  end

  def new
    authorize! :create, Collection
    @background_image = CollectionBackgroundImage.new
    @form =  Panel::CreateCollectionForm.new
  end

  def create
    authorize! :create, Collection
    @form = Panel::CreateCollectionForm.new(collection_form_params)
    service = Panel::CreateCollectionService.new(@form, current_user)

    if service.call
      redirect_to edit_panel_collection_path(service.collection, step: :collection_contents),
        notice: _('Collection was successfully created.')
    else
      render :new
    end
  end

  def edit
    authorize! :update, Collection
    step = params['step'] || 'edit'
    if step =='edit'
      @form = Panel::UpdateCollectionForm.new(collection_attributes)
      @background_image = @collection.background_image
      render :edit
    elsif step == 'collection_contents'
      @form = Panel::UpdateCollectionContentsForm.new(collection_contents_attributes)
      render :collection_contents
    end
  end

  def update
    authorize! :update, Collection
    step = params['step'] || 'update'
    if step == 'update'
      @form = Panel::UpdateCollectionForm.new(
        collection_attributes,
        collection_form_params
      )
      service = Panel::UpdateCollectionService.new(@collection, @form)

      if service.call
        redirect_to edit_panel_collection_path(@collection, step: :collection_contents),
          notice: _('Collection was successfully updated.')
      else
        render :edit
      end
    elsif step == 'collection_contents'
      @form = Panel::UpdateCollectionContentsForm.new(
        collection_contents_attributes,
        collection_contents_form_params
      )

      service = Panel::CreateCollectionContentsService.new(@collection, @form)

      if service.call
        redirect_to panel_collections_path,
          notice: _('Collection was successfully created.')
      else
        render :collection_contents
      end
    else
      redirect_to panel_collections_path
    end
  end

  def destroy
    authorize! :destroy, Collection
    @collection.destroy

    redirect_to panel_collections_path, notice: _('Collection was successfully deleted.')
  end

  def sort
    authorize! :update, Collection
    service = Panel::SortCollectionContentsService.new(@collection, sort_params)
    service.call
    render nothing: true
  end

  def update_images
    authorize! :update, Collection
    @collection.cover_image.update_attributes(cover_image_params)
    @collection.cover_image.file.recreate_versions!
    @collection.background_image.update_attributes(background_image_params)
    @collection.background_image.file.recreate_versions!

    render 'background_image', layout: false
  end

  private
  def set_collection
    @collection = Collection.find(params[:id])
  end

  def set_presenter
    @presenter = ::CollectionPresenter.new
  end

  def collection_search_params
    params.permit(:sort, :direction, :search, :page).merge(admin_id: current_admin.id)
  end

  def sort_params
    params.require(:order)
  end

  def collection_attributes
    @collection.slice('id', 'name')
  end

  def collection_form_params
    params.require(:collection_form).permit(:name, background_image: [:file])
  end

  def collection_contents_attributes
    { collection_contents: @collection.collection_contents.order(:position)
      .select(:id, :content_type, :content_id, :position, :width)
    }
  end

  def collection_contents_form_params
    params.require(:collection_form).permit(
      collection_contents_attributes:
        [:content_type, :content_id, :_destroy, :id, :position, :width]
    )
  end

  def sort_column
    ['created_at', 'name', 'collection_contents', 'products'].include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def cover_image_params
    params.require(:cover_image).permit(specification: [:crop_x, :crop_y, :width, :height, :zoom, :cropBox_x, :cropBox_y, :cropBox_width, :cropBox_height])
  end

  def background_image_params
    params.require(:background_image).permit(specification: [:crop_x, :crop_y, :width, :height, :zoom, :cropBox_x, :cropBox_y, :cropBox_width, :cropBox_height])
  end
end
