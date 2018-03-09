class FeedSerializer
  def initialize(feed)
    @feed = feed
  end

  def results
    return '' unless @feed
    prepare_feed_structure
    add_feed_to_structure

    @feed_json
  end

  private
  def prepare_feed_structure
    @feed_json = {
      combo_containers: [],
      media_containers: []
    }
  end

  def add_feed_to_structure
    @feed.each_with_index do |object, index|
      if object.class.to_s == 'MediaContainer'
        generate_media_container_content(object, index)
      elsif object.class.to_s == 'ProductsContainer'
        generate_combo_container_content(object, index)
      end
    end
  end

  def generate_media_container_content(object, index)
    media_container = MediaContainerSerializer.new(object).results
    @feed_json[:media_containers] << media_container.merge(position: index + 1)
  end

  def generate_combo_container_content(object, index)
    products_container = ProductsContainerSerializer.new(object).results
    @feed_json[:combo_containers] << products_container.merge(position: index + 1)
  end
end
