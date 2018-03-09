class Api::V1::WishlistsController < Api::V1::BaseController
  before_action :authenticate_api_v1_user!

  def index
    products = current_api_v1_user.saved_products

    render json: products.map { |product|
      ProductSerializer.new(product, with_similar_products: false).results
    }
  end

  def toggle
    form = Panel::ToggleWishlistForm.new(wishlists_params.merge(user_id: current_api_v1_user.id))
    service = Panel::ToggleWishlistService.new(form)

    if service.call
      render json: {
          is_on_wishlist: current_api_v1_user.is_wishing?(form.product_id),
          user_wishlist_count: current_api_v1_user.wishlists.count
      }
    else
      render json: form.errors.full_messages, status: 400
    end
  end

  def delete_multi
    unless params[:ids].nil? || params[:ids].empty?
      params[:ids].each do |p|
        form = Panel::ToggleWishlistForm.new({product_id: p, user_id: current_api_v1_user.id})
        service = Panel::ToggleWishlistService.new(form)
        service.call
      end
    end
    render nothing: true, status: 200
  end

  private

  def wishlists_params
    params.permit(:product_id)
  end
end
