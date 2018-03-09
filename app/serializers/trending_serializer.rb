class TrendingSerializer
  def initialize(trending)
    @trending = trending
  end

  def results
    return {} unless @trending
    generate_trending_json
    add_content_to_structure

    @trending_json
  end

  private
  def generate_trending_json
    @trending_json = {
      collections_containers: [],
      events_containers: [],
      products_containers: [],
      media_containers: [],
      combo_containers: [],
      single_product_containers: [],
      links_containers: []
    }
  end

  def add_content_to_structure
    @trending.trending_contents.each do |trending_content|
      add_content(trending_content) if trending_content.content.present?
    end
  end

  def add_content(trending_content)
    if trending_content.content_type == 'MediaContainer'
      generate_media_container_content(trending_content)
    elsif trending_content.content_type == 'CollectionsContainer'
      generate_collections_container_content(trending_content)
    elsif trending_content.content_type == 'EventsContainer'
      generate_events_container_content(trending_content)
    elsif trending_content.content_type == 'ProductsContainer' && trending_content.content.media_owner_id.present?
      generate_combo_container_content(trending_content)
    elsif trending_content.content_type == 'ProductsContainer'
      generate_products_container_content(trending_content)
    elsif trending_content.content_type == 'Product'
      generate_single_product_container_content(trending_content)
    elsif trending_content.content_type == 'Link'
      generate_link_container_content(trending_content)
    end
  end

  def generate_media_container_content(trending_content)
    media_container = MediaContainerSerializer.new(trending_content.content).results
    @trending_json[:media_containers] << media_container.merge(trending_content_attributes(trending_content))
  end

  def generate_collections_container_content(trending_content)
    collections_container = CollectionsContainerSerializer.new(trending_content.content).results
    @trending_json[:collections_containers] << collections_container.merge(trending_content_attributes(trending_content))
  end

  def generate_events_container_content(trending_content)
    events_container = EventsContainerSerializer.new(trending_content.content).results
    @trending_json[:events_containers] << events_container.merge(trending_content_attributes(trending_content))
  end

  def generate_combo_container_content(trending_content)
    combo_container = ProductsContainerSerializer.new(trending_content.content).results
    @trending_json[:combo_containers] << combo_container.merge(trending_content_attributes(trending_content))
  end

  def generate_products_container_content(trending_content)
    product_container = ProductsContainerSerializer.new(trending_content.content).results
    @trending_json[:products_containers] << product_container.merge(trending_content_attributes(trending_content))
  end

  def generate_single_product_container_content(trending_content)
    single_product_container = ProductSerializer.new(trending_content.content).results
    @trending_json[:single_product_containers] << single_product_container.merge(trending_content_attributes(trending_content))
  end

  def generate_link_container_content(trending_content)
    link = LinkSerializer.new(trending_content.content).results
    @trending_json[:links_containers] << link.merge(trending_content_attributes(trending_content))
  end

  def trending_content_attributes(trending_content)
    {
      position: trending_content.position,
      width: content_width(trending_content)
    }
  end

  def content_width(trending_content)
    trending_content.width || 'full'
  end
end
