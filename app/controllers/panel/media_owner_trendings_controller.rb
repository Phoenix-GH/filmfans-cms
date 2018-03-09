class Panel::MediaOwnerTrendingsController < Panel::BaseController
  before_action :set_presenter
  before_action :set_manual_post, only: [:show, :edit, :update, :destroy, :toggle_visibility, :products, :update_products]

  def index
    @manual_posts = ManualPostQuery.new(manual_post_search_params).results
  end

  def new
    authorize! :create, MediaOwner
    @form = Panel::CreateMediaOwnerTrendingForm.new
  end

  def create
    authorize! :create, MediaOwner

    @form = Panel::CreateMediaOwnerTrendingForm.new(trending_form_params)
    service = Panel::CreateMediaOwnerTrendingService.new(@form)

    @created_manual_post = service.call
    if @created_manual_post
      redirect_to products_panel_media_owner_trending_path(@created_manual_post),
                  notice: _('Manual Post was successfully created.')
    else
      render :new
    end
  end

  def edit
    authorize! :edit, @manual_post.media_owner
    @form = Panel::UpdateMediaOwnerTrendingForm.new(media_post_params, {})
  end

  def update
    authorize! :edit, @manual_post.media_owner

    @form = Panel::UpdateMediaOwnerTrendingForm.new(media_post_params, trending_form_params)
    service = Panel::UpdateMediaOwnerTrendingService.new(@manual_post, @form)

    if service.call
      redirect_to products_panel_media_owner_trending_path(@manual_post),
                  notice: _('Manual Post was successfully updated.')
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @manual_post.media_owner
    @manual_post.destroy

    redirect_to panel_media_owner_trendings_path, notice: _('Manual Post was successfully deleted.')
  end

  def products
    @presenter = ProductsPresenter.new
    @form = Panel::UpdateManualPostProductForm.new(manual_post_attributes)
  end

  def update_products
    @presenter = ProductsPresenter.new
    @form = Panel::UpdateManualPostProductForm.new(
        manual_post_attributes,
        media_post_form_params
    )
    service = Panel::UpdateManualPostProductsService.new(@manual_post, @form)
    if service.call
      redirect_to products_panel_media_owner_trending_path(@manual_post),
                  notice: _('Linked products were successfully updated.')
    else
      render :products
    end
  end

  def toggle_visibility
    authorize! :update, @manual_post

    service = Panel::ToggleService.new(@manual_post, :visible)
    service.call

    respond_to do |format|
      format.js do
        render layout: false
      end
    end
  end

  private

  def set_manual_post
    @manual_post = ManualPost.find(params[:id])
  end

  def sort_column
    ['name']
  end

  def set_presenter
    @presenter = MediaOwnersPresenter.new
  end

  def manual_post_search_params
    params.permit(:sort, :direction, :search, :page, :owner_id)
  end

  def media_post_params
    media_post_params = @manual_post.slice(:name, :visible)

    unless @manual_post.channel_id.blank?
      media_post_params = media_post_params.merge(:owner_id => "Channel:#{@manual_post.channel_id}")
    else
      media_post_params = media_post_params.merge(:owner_id => "MediaOwner:#{@manual_post.media_owner_id}")
    end

    media_post_params
  end

  def trending_form_params
    trending_form_params = params.require(:manual_post_form).permit(:name, :owner_id, :image, :video, :visible, :display_option)

    owner_param = trending_form_params[:owner_id]

    unless owner_param.blank?
      trending_form_params = trending_form_params.except([:owner_id])
      owner_id = owner_param[owner_param.index(':') + 1, owner_param.length - 1]
      if owner_param.include?('Channel:')
        trending_form_params = trending_form_params.merge(:channel_id => owner_id)
        trending_form_params[:display_option] = ManualPost::DISPLAY_SOCIAL_ONLY
      else
        trending_form_params = trending_form_params.merge(:media_owner_id => owner_id)
      end
    end

    trending_form_params
  end

  def manual_post_attributes
    @manual_post.slice(
        'id'
    ).merge(manual_post_products: @manual_post.manual_post_products.select(:id, :product_id, :position))
  end

  def media_post_form_params
    params.fetch(:manual_post_products_form, {}).permit(
        manual_post_products_attributes: [:id, :product_id, :position, :_destroy]
    )
  end

end
