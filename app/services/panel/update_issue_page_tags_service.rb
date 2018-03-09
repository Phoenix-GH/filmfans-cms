class Panel::UpdateIssuePageTagsService
  def initialize(issue_page, tags)
    @issue_page = issue_page
    @tags = tags
  end

  def update_tags
    ActiveRecord::Base.transaction do
      retaining_tag_ids = update_existing_tags
      new_tags = extract_new_tags_data
      delete_tags(retaining_tag_ids)
      create_new_tags(new_tags)
    end
  end

  private

  def update_existing_tags
    retaining_tag_ids = []

    @tags&.each do |tag|
      if tag['tag_id'].present? && tag['tag_id'] > 0
        retaining_tag_ids << tag['tag_id']
        page_tag = IssuePageTag.find(tag['tag_id'])
        page_tag.update_attributes(build_tag_attributes(tag))
        save_tag_products(page_tag, tag['product_ids'])
      end
    end
    retaining_tag_ids
  end

  def extract_new_tags_data
    new_tags = []

    @tags&.each do |tag|
      if !tag['tag_id'].present? || tag['tag_id'] <= 0
        new_tags << {tag: build_tag_attributes(tag), product_ids: tag['product_ids']}
      end
    end
    new_tags
  end

  def delete_tags(retaining_tag_ids)
    # figure out ID of deleted tags
    tag_ids_to_delete = []
    @issue_page.issue_page_tags.each do |tag|
      unless retaining_tag_ids.include?(tag.id)
        tag_ids_to_delete << tag.id
      end
    end

    # delete tags: delete from DB and remove from the 1-n collection
    unless tag_ids_to_delete.empty?
      @issue_page.issue_page_tags.delete(*tag_ids_to_delete)
    end
  end

  def create_new_tags(new_tags)
    new_tags.each do |new_tag|
      page_tag = IssuePageTag.new(new_tag[:tag])
      page_tag.save!
      save_tag_products(page_tag, new_tag[:product_ids])
    end
  end

  def build_tag_attributes(tag_param)
    {
        issue_page: @issue_page,
        specification: tag_param['specification']
    }
  end

  def save_tag_products(issue_page_tag, products_ids)
    issue_page_tag.issue_tag_products.delete_all

    products_ids&.each_index do |index|
      position = index
      product = Product.find(products_ids[index])
      issue_page_tag.issue_tag_products.create(product: product, position: position)
    end
  end

end