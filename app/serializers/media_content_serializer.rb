class MediaContentSerializer
  def initialize(media_content)
    @media_content = media_content
  end

  def results
    return '' unless @media_content
    generate_media_content_json
  end

  private
  def generate_media_content_json
    {
      image_url: @media_content.large_image_url,
      type: @media_content.file_type,
      url: @media_content.file.url.to_s,
      thumbnail_url: @media_content.file_thumb_url.to_s,
      media_container_url: @media_content.media_container_image_url,
      combo_container_url: @media_content.combo_container_image_url,
      specification: @media_content.specification.to_h
    }
  end
end
