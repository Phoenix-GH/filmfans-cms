class VideosSerializer
  def initialize(owner, params)
    @owner = owner
    @number_of_posts = params[:number_of_posts] || 25
    @timestamp = params[:timestamp] || Time.now.to_i
  end

  def results
    return '' unless @owner
    generate_json
    prepare_posts
    prepare_media_containers
    sort_and_filter
    add_to_json

    @json
  end

  private
  def generate_json
    @json = {social_media_containers: [], media_containers: []}
  end

  def prepare_posts
    @posts = []
    @manual_posts = []
    if @owner.feed_active?
      @posts = @owner.all_posts.visible.video.until(@timestamp.to_i).first(@number_of_posts.to_i)
      @posts = @posts.map { |p| PostSerializer.new(p).results }

      @manual_posts = @owner.all_manual_posts.visible.social.video.until(@timestamp.to_i).first(@number_of_posts.to_i)
      @manual_posts = @manual_posts.map { |m| ManualPostSerializer.new(m).results }
    end
  end

  def prepare_media_containers
    @media_containers = @owner.all_video_media_containers
    @media_containers = @media_containers.until(@timestamp.to_i).first(@number_of_posts.to_i)
    @media_containers = @media_containers.map { |mc| MediaContainerSerializer.new(mc).results }
  end

  def sort_and_filter
    @all = @posts + @media_containers + @manual_posts
    @all = SocialFeedSerializer::take_latest_post_jsons(@all, @number_of_posts.to_i)
  end

  def add_to_json
    posts_jsons = []
    media_containers_jsons = []

    @all.each do |container|
      case container[:type]
        when 'social_media_container' then
          posts_jsons << container
        when 'media_container' then
          media_containers_jsons << container
      end
    end

    @json[:social_media_containers] = posts_jsons
    @json[:media_containers] = media_containers_jsons
  end
end
