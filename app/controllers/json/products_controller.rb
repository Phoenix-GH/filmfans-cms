class Json::ProductsController < ApplicationController
  def index
    @products = ProductQuery.new(search_params).results

    render json: @products.map { |product|
      Json::ProductsController::serialize_one_product product
    }
  end

  def self.serialize_one_product product
    {
        name: product.name.truncate(50),
        id: product.id,
        image: product.image_display_url || ActionController::Base.helpers.image_url('fallback/small_thumb_default_picture.png'),
        thumb: product.image_display_url || ActionController::Base.helpers.image_url('fallback/small_thumb_default_picture.png'),
        brand: product.brand,
        price: product.price,
        vendor: product.vendor,
        vendor_url: product.vendor_url,
        available: product.available
    }
  end

  private

  def search_params
    params.permit(:search, :category_id, :vendor, :page, :per, :available, product_ids: [])
  end
end
