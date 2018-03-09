class ManualPostContainerSerializer
  def initialize(container)
    @container = container
  end

  def results
    return nil unless @container
    generate_container_json

    @container_json
  end

  private

  def generate_container_json
    @container_json = {
        type: 'manual_post_container',
        id: @container.id,
        name: @container.name.to_s,
        content: posts_json
    }
  end

  def posts_json
    @container.linked_manual_posts.order(:position).map do |link|
      ManualPostSerializer.new(
          link.manual_post, true
      ).result_embed_one_product.merge(event_position: link.position)
    end
  end
end