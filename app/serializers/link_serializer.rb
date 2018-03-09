class LinkSerializer
  def initialize(link, current_country)
    @link = link
    @current_country = current_country
  end

  def results
    return nil unless @link

    # Check for visibility of channel
    if @link.target_type == Channel.name
      return nil unless @link.target.visibility
    end

    # Check for visibility of magazine
    if @link.target_type == Magazine.name
      return nil unless @link.target.channel.visibility
    end

    # Filtering magazine & tv shows by current country
    unless @current_country.blank?
      # Reject channel don't belong to current country
      return nil if @link.target_type == Channel.name and @link.target.countries.length != 0 and not @link.target.countries.include? @current_country.downcase

      # Reject magazine that belong to channels that don't belong to current country
      return nil if @link.target_type == Magazine.name and @link.target.channel.countries.length != 0 and not @link.target.channel.countries.include? @current_country.downcase
    end

    generate_link_json
    merge_number_of_isses

    @link_json
  end

  private
  def generate_link_json
    @link_json = {
      id: @link.id,
      target_id: @link.target.id,
      name: target_title,
      type: 'link_container',
      link_type: @link.target_type.underscore,
      number_of_videos: number_of_videos.to_i,
      description: target_description.to_s,
      image_url: cover_image_url
    }
  end

  def target_title
    @link.target.try(:name) || @link.target.try(:title)
  end

  def number_of_videos
    @link.videos.size
  end

  def merge_number_of_isses
    if @link.target_type == 'Magazine'
      @link_json.merge!(number_of_issues: @link.target.issues.count)
    end
  end

  def target_description
    @link.target.try(:description)
  end

  def cover_image_url
    if @link.target_type == 'MediaOwner' || @link.target_type == 'Channel'
      @link.target.picture.present? ? @link.target.picture.custom_url : ''
    elsif @link.target_type == 'Event' || @link.target_type == 'TvShow' || @link.target_type == 'Magazine'
      @link.target.cover_image.present? ? @link.target.cover_image.custom_url : ''
    end
  end
end
