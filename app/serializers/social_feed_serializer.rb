class SocialFeedSerializer
  def initialize(source_owner, params)
    @source_owner = source_owner
    @number_of_posts = params[:number_of_posts] || 25
    @timestamp = params[:timestamp] || Time.now.to_i
  end

  def results
    return '' unless @source_owner
    generate_social_feed_json
  end

  def self.take_latest_post_jsons(posts_jsons, number_of_posts)
    posts_jsons = posts_jsons.reject { |a| a == '' || a.nil? }
    posts_jsons.sort_by { |a| a[:date] }.reverse.first(number_of_posts.to_i)
  end

  private
  def generate_social_feed_json
    posts_jsons = []

    if @source_owner.feed_active?
      manual_posts = @source_owner.all_manual_posts.visible.social.until(@timestamp.to_i).first(@number_of_posts.to_i)

      manual_posts.each { |m| posts_jsons << ManualPostSerializer.new(m).results }

      posts = @source_owner.all_posts.visible.until(@timestamp.to_i).first(@number_of_posts.to_i)

      posts.each { |p| posts_jsons << PostSerializer.new(p).results }

      posts_jsons = SocialFeedSerializer::take_latest_post_jsons(posts_jsons, @number_of_posts.to_i)

      posts_jsons = posts_jsons.take(@number_of_posts.to_i)
    end

    {social_media_containers: posts_jsons}
  end
end
