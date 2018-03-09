class Panel::PostsController < Panel::BaseController
  before_filter :load_source_owner, only: [:feed, :videos, :edit, :update]
  before_action :set_post, only: [:edit, :update]

  def edit
    @presenter = ProductsPresenter.new
    @form = Panel::UpdatePostProductsForm.new(post_products_attributes)
    render :edit
  end

  def update
    @presenter = ProductsPresenter.new
    @form = Panel::UpdatePostProductsForm.new(
      post_products_attributes,
      post_products_form_params
    )
    service = Panel::UpdatePostProductsService.new(@post, @form)
    if service.call
      if @post.source.source_owner.class.to_s == 'MediaOwner'
        redirect_to feed_panel_media_owner_posts_path(@post.source.source_owner)
      elsif @post.source.source_owner.class.to_s == 'Channel'
        redirect_to feed_panel_channel_posts_path(@post.source.source_owner)
      end
    else
      render :edit
    end
  end

  def feed
    @posts = PostQuery.new(@source_owner, posts_search_params).results
  end

  def toggle_visibility
    @post = Post.find(params[:id])

    service = Panel::ToggleService.new(@post, :visible)
    service.call
    respond_to do |format|
      format.js do
        render layout: false
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_products_attributes
    @post.slice(
      'id'
    ).merge(post_products: @post.post_products.select(:id, :product_id, :position))
  end

  def post_products_form_params
    params.fetch(:post_products_form, {}).permit(
      post_products_attributes: [:id, :product_id, :position, :_destroy]
    )
  end

  def posts_search_params
    params.permit(:source_id, :page)
  end

  def sort_column
    'published_at'
  end

  def sort_direction
    'desc'
  end

  def load_source_owner
    if params[:media_owner_id].present?
      @source_owner = MediaOwner.find(params[:media_owner_id])
      authorize! :update, @source_owner
    elsif params[:channel_id].present?
      @source_owner = Channel.find(params[:channel_id])
      authorize! :update, @source_owner
    end
  end
end
