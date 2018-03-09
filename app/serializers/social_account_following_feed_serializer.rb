class SocialAccountFollowingFeedSerializer
  def initialize(social_feed, with_product = false)
    @social_feed = social_feed
    @with_product = with_product
  end

  def results
    generate_json
  end

  private
  def generate_json
    additional_info = {
        type: 'social_media_container',
        width: 'half',
        icon: Rails.application.secrets.domain_name + "/icons/#{@social_feed[:website]}.png",
        has_products: false
    }
    @social_feed.merge(additional_info)
  end
end
