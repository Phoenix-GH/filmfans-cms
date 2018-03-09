class CategoryTreeSerializer

  def results
    tree = Rails.cache.read('tree_categories')
    return tree unless tree.nil?

    tree = {
        man: category_json(Category.find(Category::MAN_CATEGORY_ID)),
        woman: category_json(Category.find(Category::WOMAN_CATEGORY_ID)),
    }

    Rails.cache.write('tree_categories', tree, time_to_idle: 1.hours, timeToLive: 3.hours)

    tree
  end

  private
  def category_json(category)
    {
        id: category.id,
        name: category.name.to_s,
        code: category.imaging_category,
        subcategories: generate_subcategories(category)
    }
  end

  def generate_subcategories(category)
    category.subcategories
        .reject { |sub_cat| sub_cat.id < Category::IN_USED_CATEGORY_START_ID || sub_cat.hidden }
        .map { |sub_cat| category_json(sub_cat) }
  end

end
