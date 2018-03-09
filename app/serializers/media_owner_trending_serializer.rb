class MediaOwnerTrendingSerializer

  def initialize(media_owner_trending)
    @media_owner_trending = media_owner_trending
  end

  def results
    return nil unless @media_owner_trending
    generate_media_owner_trending_json
    add_product_details

    @media_owner_trending_json
  end

  private
  def generate_media_owner_trending_json
    @media_owner_trending_json = {
        id: @media_owner_trending.id,
        trending_name: @media_owner_trending.name,
        trending_image_url: @media_owner_trending.custom_url,
        media_owner_id: @media_owner_trending.media_owner_id,
        media_owner_name: @media_owner_trending.media_owner&.name,
        media_owner_avatar_url: @media_owner_trending.media_owner&.picture.present? ? @media_owner_trending.media_owner.picture.custom_url : '',
        channel_id: @media_owner_trending.channel_id,
        channel_name: @media_owner_trending.channel&.name,
        channel_avatar_url: @media_owner_trending.channel&.picture.present? ? @media_owner_trending.channel.picture.custom_url : ''
    }
  end

  def add_product_details
    products_jsons = []
    @media_owner_trending.products.each do |p|
      products_jsons << ProductSerializer.new(p, with_similar_products: false).results if p.present?
    end

    @media_owner_trending_json.merge!(
        products: products_jsons
    )
  end

end