class MagazineSerializer
  def initialize(magazine, with_issues: false)
    @magazine = magazine
    @with_issues = with_issues
  end

  def results
    return '' unless @magazine
    generate_magazine_json
    add_issues

    @magazine_json
  end

  private
  def generate_magazine_json
    @magazine_json = {
      id: @magazine.id,
      name: @magazine.title.to_s,
      description: @magazine.description.to_s,
      issues_count: @magazine.issues.count.to_i,
      volume_count: @magazine.volumes.count.to_i,
      cover_image_url: @magazine.cover_image.present? ? @magazine.cover_image.custom_url : '',
      channel: channel_details
    }
  end

  def channel_details
    return {} unless @magazine.channel
    {
      id: @magazine.channel_id,
      name: @magazine.channel.name.to_s,
      thumbnail_url: @magazine.channel&.picture.present? ? @magazine.channel.picture.custom_url : ''
    }
  end
  def add_issues
    return unless @with_issues

    volumes = @magazine.volumes.map do |volume|
      VolumeSerializer.new(volume).results
    end

    @magazine_json.merge!(volumes: volumes)
  end
end
