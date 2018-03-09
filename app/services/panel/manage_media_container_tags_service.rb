class Panel::ManageMediaContainerTagsService
  def initialize(media_container, data)
    @media_container = media_container
    @data = data
  end

  def call
    return false unless @media_container

    ActiveRecord::Base.transaction do
      remove_media_container_tags
      add_media_container_tags
    end
  end

  private

  def remove_media_container_tags
    @media_container.tags.delete_all
  end

  def add_media_container_tags
    @data.each_value do |value|
      next unless product = Product.find_by(name: value[:text])

      @media_container.tags.create(
        coordinate_x: value[:x],
        coordinate_y: value[:y],
        product_id: product.id
      )
    end
  end
end
