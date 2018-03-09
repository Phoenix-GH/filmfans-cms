class Panel::UpdateMovieCelebrityMappingForm
  include ActiveModel::Model

  INSTAGRAM_URI_PREFIX = 'https://www.instagram.com/'

  attr_accessor(
      :id, :name, :instagram_url, :instagram_status
  )

  def initialize(movie_celebrity_mappings_attrs, form_attributes = {})
    super movie_celebrity_mappings_attrs.merge(form_attributes)
  end

  validate :valid_instagram_account

  def movie_celebrity_attributes
    {
        instagram_id: extract_instagram_id,
        instagram_status: instagram_status
    }
  end

  def extract_instagram_id
    return nil if instagram_status == MovieCelebrityMapping::INSTAGRAM_STATUS_NO_ACCOUNT

    url = instagram_url&.strip

    return nil if url.blank? || !url.start_with?(INSTAGRAM_URI_PREFIX)

    id = url[INSTAGRAM_URI_PREFIX.length..url.length - 1]

    # remove leading slash (/)
    id = id.gsub(/^[\/]*/, '')

    # remove traling slash
    id.gsub(/[\/]*$/, '')
  end

  private

  def valid_instagram_account
    return if instagram_url.blank? || instagram_status == MovieCelebrityMapping::INSTAGRAM_STATUS_NO_ACCOUNT

    unless instagram_url.start_with?(INSTAGRAM_URI_PREFIX)
      errors[:instagram_url] << "Instagram URL must start with #{INSTAGRAM_URI_PREFIX}"
      return
    end

    id = extract_instagram_id
    if id.blank?
      errors[:instagram_url] << 'Invalid Instagram URL: cannot determine account ID from the URL. Please make sure it is a correct Instagram page of the celebrity'
      return
    end

    if instagram_status == MovieCelebrityMapping::INSTAGRAM_STATUS_NOT_FOLLOWED
      return
    end

    posts = Social::SocialService.new.get_feeds(following_ids: id, timestamp: nil, number_of_posts: 1)

    if posts.blank?
      errors[:instagram_url] << 'This social account is not followed by HotSpotting/HotSpotMe'
      return
    end
  end
end