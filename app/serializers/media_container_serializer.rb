class MediaContainerSerializer

  def initialize(media_container, with_tags = false)
    @media_container = media_container
    @with_tags = with_tags
  end

  def results
    return '' unless @media_container
    generate_media_container_json
    add_tags

    @media_container_json
  end

  private

  def generate_media_container_json
    @media_container_json = {
        type: 'media_container',
        id: @media_container.id,
        date: @media_container.created_at.to_i,
        name: @media_container.name&.upcase,
        description: @media_container.description.to_s,
        additional_description: @media_container.additional_description.to_s,
        width: 'half',
        owner: owner_json,
        content: content_json
    }
  end

  def owner_json
    OwnerSerializer.new(@media_container.owner).results
  end

  def content_json
    ShortMediaContentSerializer.new(@media_container.media_content).results
  end

  def add_tags
    return unless @with_tags

    @media_container_json.merge!(tags: @media_container.tags.map do |tag|
      TagSerializer.new(tag).results
    end)
  end
end
