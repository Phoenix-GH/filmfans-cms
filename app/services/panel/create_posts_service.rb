class Panel::CreatePostsService

  def initialize(source_owner, dialogfeed_posts)
    @source_owner = source_owner
    @dialogfeed_posts = dialogfeed_posts
  end

  def call
    [@dialogfeed_posts].flatten.reject(&:nil?).reverse_each do |post|

      # Check if website is allowed
      website = post['source']['name']
      next unless website.in? Source.allowed_websites

      # Check if source exists
      source_dialogfeed_id = post['source']['id']
      source = @source_owner.sources.find_by(dialogfeed_id: source_dialogfeed_id, website: website)
      next if source.blank?

      # Check if post contains picture or video
      content = post['content']
      content_picture = content['content_picture']
      content_video_url = content['content_video_url']
      next if content_picture.blank? && content_video_url.blank?

      published_at = post['created_at_std']
      content_title = content['content_title']
      content_body = content['content_body']
      post_url = post['source']['source_url']
      uid = post['uid']

      author_id = post['author']['id']
      author_name = post['author']['name']
      author_url = post['author']['url']
      author_picture_url = post['author']['picture_url']

      # Dialogfeed confuses two parameters for Instagram videos, hack below
      if website == 'instagram' && content_video_url.present? && post_url.present?
        content_video_url, post_url = post_url, content_video_url
      end

      post_type = content_picture.present? ? 'image' : 'video'

      # Check if video is a native video
      next if post_type == 'video' && !(/\.mp4/).match(content_video_url)

      # Check if post does not already exist
      next if source.posts.where(uid: uid).any?

      # Create post
      source.posts.create(
          published_at: published_at,
          content_title: content_title,
          content_body: content_body,
          remote_content_picture_url: content_picture,
          original_picture_url: content_picture,
          remote_content_video_url: content_video_url,
          original_video_url: content_video_url,
          post_url: post_url,
          uid: uid,
          post_type: post_type,
          author_id: author_id,
          author_name: author_name,
          author_url: author_url,
          author_picture_url: author_picture_url
      )
    end
  end

end
