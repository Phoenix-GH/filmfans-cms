class CategorySerializer
  def initialize(category, with_children = false)
    @category = category
    @with_children = with_children
  end

  def results
    return '' unless @category
    if @with_children
      generate_category_with_children_json
    else
      generate_category_json
    end
  end

  def self.generate_categories_array_for_apps
    roots = Rails.cache.read('apps_display_categories')
    return roots unless roots.nil?

    parent_categories = CategoryQuery.new.results

    roots = parent_categories.map do |category|
      unless category.hidden
        CategorySerializer.new(category, true)
            .results
            .merge(type: 'category')
      end
    end

    roots = roots.compact

    Rails.cache.write('apps_display_categories', roots, time_to_idle: 1.hours, timeToLive: 3.hours)

    roots
  end

  def self.generate_categories_for_apps_merchandise
    cat_list = Rails.cache.read('categories_for_apps_merchandise')
    return cat_list unless cat_list.blank?

    # for filmfans, all products are manually input, not massive imported like hotspotting
    # only categories having products
    query_ids = ProductCategory
                    .where.not(category_id: Category::QUARANTINE_CATEGORY_ID)
                    .select(:category_id)
                    .distinct.map { |c| c.category_id }

    target_level = 1
    cat_ids = []
    until query_ids.blank?
      cats = Category.where(id: query_ids)
      query_ids = []
      cats.each do |c|
        if c.level == target_level
          cat_ids << c.id
        elsif !c.parent_id.blank?
          query_ids << c.parent_id
        end
      end
    end

    cat_list = []
    cats_by_name = {}
    Category.where(id: cat_ids).each do |c|
      dto = cats_by_name[c.name]
      if dto.blank?
        dto = {
            name: c.name,
            ids: [c.id]
        }
        cats_by_name[c.name] = dto
        cat_list << dto
      else
        dto[:ids] << c.id
      end
    end
    cat_list = cat_list.sort_by { |c| c[:name] }

    Rails.cache.write('categories_for_apps_merchandise', cat_list, time_to_idle: 15.minutes, timeToLive: 15.minutes)

    cat_list
  end

  private
  def generate_category_json
    {
      id: @category.id,
      parent_id: @category.parent_id.to_s,
      name: @category.name.to_s,
      image: @category.image_url.to_s,
      icon: @category.icon_url.to_s
    }
  end

  def generate_category_with_children_json
    {
      id: @category.id,
      name: @category.name.to_s,
      icon_url: @category.icon.carousel.url.to_s,
      subcategories: generate_subcategories_json
    }
  end

  def generate_subcategories_json
    subcategories = []
    Category.where(level: Category::DISPLAY_LEVEL).where(hidden: false).each do |leaf_entity|
      name_arr = []
      top_parent_entity = Category::build_sub_category_name(leaf_entity, name_arr, false)

      if @category.id == top_parent_entity.id
        subcategories << CategoryDto.new(leaf_entity.id, name_arr.join(' > '), leaf_entity.parent_id)
      end
    end

    subcategories.sort_by { |e| [e.parent_id, e.name] }
  end

end
