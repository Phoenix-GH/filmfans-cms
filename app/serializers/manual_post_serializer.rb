class ManualPostSerializer
  def initialize(post, include_products = false)
    @manual_post = post
    @include_products = include_products
  end

  def results
    return '' unless @manual_post
    generate_post_json
    add_products if @include_products

    @manual_post_json
  end

  def result_embed_one_product
    return '' unless @manual_post
    generate_post_json

    @manual_post_json.merge({product: nil})
    if @manual_post.products.length > 0
      @manual_post_json[:product] = ProductSerializer.new(@manual_post.products.first,
                                                          with_variants: false,
                                                          with_similar_products: false).results
    end
    @manual_post_json
  end

  private
  def generate_post_json
    @manual_post_json = {
        type: 'social_media_container',
        id: @manual_post.id * -1, # negavie ID to identify the manual post in feed response
        date: @manual_post.created_at.to_i,
        width: 'half',
        post_type: (@manual_post.image? ? 'image' : 'video'),
        content_title: @manual_post.name,
        content_body: '',
        post_url: '',
        website: '',
        icon: '',
        owner: owner_json,
        content: content_json,
        has_products: @manual_post.products.any?
    }
  end

  def content_json
    if @manual_post.image?
      {
          type: 'image',
          url: @manual_post.full_image_file_url,
          thumbnail_url: @manual_post.custom_url

      }
    elsif @manual_post.video?
      {
          type: 'video/mp4',
          url: @manual_post.video.full_url,
          thumbnail_url: @manual_post.video.full_video_thumb_url
      }
    else
      {}
    end
  end

  def owner_json
    OwnerSerializer.new(@manual_post.source_owner).results
  end

  def add_products
    products_jsons = []
    @manual_post.products.each do |p|
      products_jsons << ProductSerializer.new(p, with_similar_products: false).results if p.present?
    end

    @manual_post_json = {post: @manual_post_json, products: products_jsons}
  end
end
