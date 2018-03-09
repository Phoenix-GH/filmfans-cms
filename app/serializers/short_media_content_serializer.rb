class ShortMediaContentSerializer
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
      type: @media_content.file_type,
      url: @media_content.file.url.to_s,
      thumbnail_url: @media_content.file_thumb_url.to_s,
    }
  end
end
