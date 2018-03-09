class Social::SocialService

  def get_feeds(following_ids:, timestamp:, number_of_posts:)
    return [] if following_ids.blank?

    ids = following_ids.kind_of?(String) ? following_ids.to_s.split(',') : following_ids
    s_params = {
        socialType: 'instagram',
        following_ids: ids,
        timestamp: timestamp.blank? ? DateTime.now.strftime('%Y%m%d%H%M%S') : timestamp,
        number_of_posts: number_of_posts.blank? ? 25 : number_of_posts
    }

    puts s_params.to_json

    social_feeds = []
    begin
      RestClient.post("#{ENV['CRAWLER_URL']}/feeds", s_params.to_json, {content_type: 'application/json; charset=utf-8', accept: :json}) { |res|
        case res.code
          when 200
            social_feeds = JSON.parse(res.body)['feedList'] || []
          else
            Rails.logger.error res
        end
      }
    rescue Exception => e
      LogHelper::log_exception(e)
    end
    social_feeds
  end

end