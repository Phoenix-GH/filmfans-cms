class DiscoverySerializer
  def initialize(klass, params)
    @klass = klass
    @number_of_posts = params[:number_of_posts] || 25
    @timestamp = params[:timestamp] || Time.now.to_i
    @current_country = params[:current_country]
  end

  def results
    return '' unless @klass.in? [Channel, MediaOwner]
    generate_discovery_json
  end

  private
  def generate_discovery_json
    posts_ids = []
    manual_post_ids = []

    filter_by_country.each do |source_owner|
      if (source_owner.instance_of?(Channel))
        posts_ids.push(*source_owner.all_posts.map(&:id)) if (source_owner.feed_active? and source_owner.visibility?)
        manual_post_ids.push(*source_owner.all_manual_posts.map(&:id)) if (source_owner.feed_active? and source_owner.visibility?)
      else
        posts_ids.push(*source_owner.all_posts.map(&:id)) if source_owner.feed_active?
        manual_post_ids.push(*source_owner.all_manual_posts.map(&:id)) if source_owner.feed_active?
      end
    end

    posts = Post.where('id IN (?)', posts_ids.uniq).visible.until(@timestamp.to_i).first(@number_of_posts.to_i)
    manual_posts = ManualPost.where('id IN (?)', manual_post_ids.uniq).visible.social.until(@timestamp.to_i).first(@number_of_posts.to_i)

    posts_jsons = []
    posts.each { |p| posts_jsons << PostSerializer.new(p).results }
    manual_posts.each { |m| posts_jsons << ManualPostSerializer.new(m).results }

    posts_jsons = SocialFeedSerializer::take_latest_post_jsons(posts_jsons, @number_of_posts.to_i)

    {social_media_containers: posts_jsons}
  end

  def filter_by_country
    return @klass.all if @current_country.blank?

    if @klass.name == Channel.name
      @klass.where("countries @> ? or countries = '[]'", "[\"#{@current_country.downcase}\"]")
    else
      @klass.all
    end
  end

end
