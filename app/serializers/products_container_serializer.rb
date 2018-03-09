class ProductsContainerSerializer
  def initialize(products_container, language = 'en')
    @products_container = products_container
    @with_owner = products_container.media_owner.present?
    @language = language
  end

  def results
    return '' unless @products_container
    generate_products_container_json
    add_combo_json

    @products_container_json
  end

  private

  def generate_products_container_json
    @products_container_json = {
        type: container_type,
        id: @products_container.id,
        name: @products_container.name_translation(@language).upcase,
        date: @products_container.created_at.to_s,
        products: generate_products_array
    }
  end

  def generate_products_array
    [].tap do |array|
      @products_container.linked_products.order(:position).map do |linked_product|
        array << ProductSerializer.new(linked_product.product, with_similar_products: false).results if linked_product.product.present?
      end
    end
  end

  def add_combo_json
    return unless @with_owner

    @products_container_json.merge!(
      description: @products_container.description,
      media_owner: media_owner_json,
      content: media_content_json
    )
  end

  def media_owner_json
    MediaOwnerSerializer.new(@products_container.media_owner).results
  end

  def media_content_json
    MediaContentSerializer.new(@products_container.media_content).results
  end

  def container_type
    @with_owner ? 'combo_container' : 'products_container'
  end
end
