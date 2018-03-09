class IssuePageSerializer
  def initialize(issue_page)
    @issue_page = issue_page
  end

  def results
    return unless @issue_page
    generate_page_json
    generate_tag_json
  end

  private
  def generate_page_json
    @issue_page_json = {
        page_image_url: @issue_page.image_url_for_apps,
    }
  end

  private
  def generate_tag_json
    tag_json = @issue_page.issue_page_tags&.reject { |tag| tag.issue_tag_products.empty? }&.map do |tag|
      {
          type: tag.specification['type'],
          # nullable, design to be used in the future if we want the backend to control the icon displayed on the phone
          tag_icon_url: IssueTagCategories::icon_url(tag.specification['type']),
          x: tag.specification['x'],
          y: tag.specification['y'],
          orientation: tag.specification['orientation'],
          products: serialize_products(tag.issue_tag_products)
      }
    end

    @issue_page_json.merge!(tags: tag_json)
  end


  def serialize_products(issue_tag_products)
    issue_tag_products.map { |issue_tag_product|
      ProductSerializer.new(issue_tag_product.product).results
    }
  end

end