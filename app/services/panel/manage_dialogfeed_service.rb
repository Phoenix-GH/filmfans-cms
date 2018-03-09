require 'net/http'
require 'json'

class Panel::ManageDialogfeedService
  include Sidekiq::Worker

  def perform(source_owner_type, source_owner_id, url, remove_old = false)
    @source_owner = source_owner_type.constantize.find(source_owner_id)
    @url = url
    return false unless @source_owner.present?
    @source_owner.sources.destroy_all if remove_old
    return false if @url.blank?
    make_call
    unless @sources.nil?
      # update_sources // Turned off. Dialogfeed doesn't update/remove existing posts anyway.
      create_sources
      # update_posts // Turned off. Dialogfeed doesn't update/remove existing posts anyway.
      create_posts
    end
  end

  private
  def make_call
    max_posts = 1000
    from_timestamp = 3.months.ago.to_i
    params = "&max=#{max_posts}&from_timestamp=#{from_timestamp}&post_nodes=created_at_std,content,source,author,uid&feed_nodes=sources"

    uri = URI(@url + params)
    response = Net::HTTP.get(uri)
    return if response.blank?

    json = JSON.parse(response)
    news_feed = json['news_feed']
    return unless news_feed.present?

    @sources = news_feed['sources'].is_a?(String) ? [] : news_feed['sources']['source']
    @posts = news_feed['posts'].is_a?(String) ? [] : news_feed['posts']['post']
  end

  def update_sources
    Panel::UpdateSourcesService.new(@source_owner, @sources).call
  end

  def create_sources
    Panel::CreateSourcesService.new(@source_owner, @sources).call
  end

  def update_posts
    Panel::UpdatePostsService.new(@source_owner, @posts).call
  end

  def create_posts
    Panel::CreatePostsService.new(@source_owner, @posts).call
  end
end
