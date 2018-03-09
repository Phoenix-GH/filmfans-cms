class EventSerializer
  def initialize(event, with_content: false)
    @event = event
    @with_content = with_content
  end

  def results
    return {} unless @event
    generate_event_json
    add_content_to_structure

    @event_json
  end

  private
  def generate_event_json
    @event_json = {
      id: @event.id.to_i,
      name: @event.name.to_s,
      type: 'event_container',
      image_url: @event.background_image.present? ? @event.background_image.custom_url : '',
      cover_image_url: @event.cover_image.present? ? @event.cover_image.custom_url : '',
      media_containers: [],
      products_containers: [],
      single_product_containers: [],
      links_containers: [],
      collections_containers: []
    }
  end

  def add_content_to_structure
    return unless @with_content

    @event.event_contents.each do |event_content|
      add_content(event_content) if event_content.content.present?
    end
  end

  def add_content(event_content)
    case event_content.content_type
    when 'MediaContainer'
      generate_media_container_content(event_content)
    when 'ProductsContainer'
      generate_products_container_content(event_content)
    when 'Product'
      generate_single_product_container_content(event_content)
    when 'Link'
      generate_link_container_content(event_content)
    when 'CollectionsContainer'
      generate_collections_container_content(event_content)
    end
  end

  def generate_media_container_content(event_content)
    media_container = MediaContainerSerializer.new(event_content.content).results
    @event_json[:media_containers] << media_container.merge(event_content_attributes(event_content))
  end

  def generate_products_container_content(event_content)
    product_container = ProductsContainerSerializer.new(event_content.content).results
    @event_json[:products_containers] << product_container.merge(event_content_attributes(event_content))
  end

  def generate_single_product_container_content(event_content)
    single_product_container = ProductSerializer.new(event_content.content).results
    @event_json[:single_product_containers] << single_product_container.merge(event_content_attributes(event_content))
  end

  def generate_link_container_content(event_content)
    link = LinkSerializer.new(event_content.content).results
    @event_json[:links_containers] << link.merge(event_content_attributes(event_content))
  end

  def generate_collections_container_content(event_content)
    collections_container = CollectionsContainerSerializer.new(event_content.content).results
    @event_json[:collections_containers] << collections_container.merge(event_content_attributes(event_content))
  end

  def event_content_attributes(event_content)
    {
      position: event_content.position,
      width: content_width(event_content)
    }
  end

  def content_width(event_content)
    event_content.width || 'full'
  end
end
