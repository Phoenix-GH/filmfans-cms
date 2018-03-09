class CollectionSerializer
  def initialize(collection, with_content = false)
    @collection = collection
    @with_content = with_content
  end

  def results
    return '' unless @collection
    generate_collection_json
    add_contents

    @collection_json
  end

  private
  def generate_collection_json
    @collection_json = {
        id: @collection.id,
        name: @collection.name&.upcase,
        image_url: @collection.cover_image.present? ? @collection.cover_image.custom_url : ''
    }
  end

  def add_contents
    return unless @with_content

    @collection_json.merge!(
      products_containers: [],
      media_containers: [],
      combo_containers: []
    )
    add_content_to_structure
  end

  def add_content_to_structure
    @collection.collection_contents.each do |col_content|
      add_content(col_content)
    end
  end

  def add_content(col_content)
    if col_content.content_type == 'MediaContainer'
      generate_media_container_content(col_content)
    elsif col_content.content_type == 'ProductsContainer' && col_content.content.media_owner_id.present?
      generate_combo_container_content(col_content)
    elsif col_content.content_type == 'ProductsContainer'
      generate_products_container_content(col_content)
    end
  end

  def generate_media_container_content(col_content)
    media_container = MediaContainerSerializer.new(col_content.content).results
    @collection_json[:media_containers] << media_container.merge(position: col_content.position)
  end

  def generate_combo_container_content(col_content)
    combo_container = ProductsContainerSerializer.new(col_content.content).results
    @collection_json[:combo_containers] << combo_container.merge(position: col_content.position)
  end

  def generate_products_container_content(col_content)
    product_container = ProductsContainerSerializer.new(col_content.content).results
    @collection_json[:products_containers] << product_container.merge(position: col_content.position)
  end
end
