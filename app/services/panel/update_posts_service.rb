class Panel::UpdatePostsService

  def initialize(source_owner, dialogfeed_posts)
    @source_owner = source_owner
    @dialogfeed_posts = dialogfeed_posts
  end

  def call
    @source_owner.posts.last_three_months.each do |post|
      # Destroy post unless dialogfeed post exists
      destroy = true

      @dialogfeed_posts.each do |df_post|
        if df_post['uid'] == post.uid

          content = df_post['content']
          content_picture = content['content_picture']
          content_video_url = content['content_video_url']

          # Destroy post if not image or video anymore
          break if content_picture.blank? && content_video_url.blank?

          content_title = content['content_title']
          content_body = content['content_body']
          post_url = df_post['source']['source_url']

          # Dialogfeed confuses two parameters for Instagram videos, hack below
          if website == 'instagram' && content_video_url.present? && post_url.present?
            content_video_url, post_url = post_url, content_video_url
          end

          post_type = content_picture.present? ? 'image' : 'video'

          # Destroy post if video is not a native video
          break if post_type == 'video' && !(/\.mp4/).match(content_video_url)

          post.remote_content_picture_url = content_picture if post.original_picture_url != content_picture
          post.remote_content_video_url = content_video_url if post.original_video_url != content_video_url
          post.content_title = content_title if post.content_title != content_title
          post.content_body = content_body if post.content_body != content_body
          post.post_url = post_url if post.post_url != post_url
          post.post_type = post_type if post.post_type != post_type

          # Update post if needed
          post.save if post.changed?

          # Do not destroy post
          destroy = false
          break
        end
      end

      post.destroy if destroy
    end
  end

end