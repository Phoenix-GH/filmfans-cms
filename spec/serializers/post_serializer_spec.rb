describe PostSerializer do
  let(:media_owner) { create(:media_owner) }
  let(:source) { create(:facebook_source, source_owner: media_owner) }

  it 'return image post' do
    post = create(:image_post, source: source)
    results = PostSerializer.new(post).results
    owner_json = OwnerSerializer.new(media_owner).results

    expect(results).to eq(
      {
        type: 'social_media_container',
        id: post.id,
        date: post.published_at.to_i,
        width: 'half',
        post_type: post.post_type,
        content_title: post.content_title,
        content_body: post.content_body,
        post_url: post.post_url,
        website: post.website,
        icon: Rails.application.secrets.domain_name + "/icons/#{post.website}.png",
        owner: owner_json,
        content: {
          type: 'image',
          url: post.content_picture.full_url,
          thumbnail_url: post.content_picture.full_url
        },
        has_products: false
      }
    )
  end

  it 'return video post' do
    post = create(:video_post, source: source)
    results = PostSerializer.new(post, false).results
    owner_json = OwnerSerializer.new(media_owner).results

    expect(results).to eq(
      {
        type: 'social_media_container',
        id: post.id,
        date: post.published_at.to_i,
        post_type: post.post_type,
        width: 'half',
        content_title: post.content_title,
        content_body: post.content_body,
        post_url: post.post_url,
        website: post.website,
        icon: Rails.application.secrets.domain_name + "/icons/#{post.website}.png",
        owner: owner_json,
        content: {
          type: 'video/mp4',
          url: post.content_video.full_url,
          thumbnail_url: post.content_video.full_video_thumb_url
        },
        has_products: false
      }
    )
  end
end
