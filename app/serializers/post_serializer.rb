class PostSerializer
  def initialize(post, include_products = false)
    @post = post
    @include_products = include_products
  end

  def results
    return '' unless @post
    generate_post_json
    add_products if @include_products

    @post_json
  end

  private
  def generate_post_json
    @post_json = {
      type: 'social_media_container',
      id: @post.id,
      date: @post.published_at.to_i,
      width: 'half',
      post_type: @post.post_type,
      content_title: @post.content_title || '',
      content_body: @post.content_body || '',
      post_url: @post.post_url,
      website: @post.website,
      icon: Rails.application.secrets.domain_name + "/icons/#{@post.website}.png",
      owner: owner_json,
      content: content_json,
      has_products: @post.products.any?
    }
  end

  def owner_json
    owner = @post.source_owner
    if owner.kind_of? Channel and !owner.key.blank? and owner.key == 'HOTSPOTME'
      {
          id: @post.author_id,
          type: owner.class.name.underscore,
          name: @post.author_name,
          url: @post.author_url,
          thumbnail_url: @post.author_picture_url,
      }
    else
      OwnerSerializer.new(@post.source_owner).results
    end
  end

  def content_json
    if @post.image?
      {
        type: 'image',
        url: @post.content_picture.full_url,
        thumbnail_url: @post.content_picture.full_url

      }
    elsif @post.video?
      {
        type: 'video/mp4',
        url: @post.content_video.full_url,
        thumbnail_url: @post.content_video.full_video_thumb_url
      }
    else
      {}
    end
  end

  def add_products
    products_jsons = []
    @post.products.each do |p|
      products_jsons << ProductSerializer.new(p, with_similar_products: false).results if p.present?
    end

    @post_json = { post: @post_json, products: products_jsons }
  end
end
