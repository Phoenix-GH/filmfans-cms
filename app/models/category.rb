class Category < ActiveRecord::Base
  DISPLAY_LEVEL = 3
  # products in this category is not shown anywhere
  # is is for taking away bad products which were imported into DB
  QUARANTINE_CATEGORY_ID = 48

  IN_USED_CATEGORY_START_ID = 50
  WOMAN_CATEGORY_ID = 40
  MAN_CATEGORY_ID = 41

  BEAUTY_CATEGORY_ID = 250

  has_many :subcategories, -> { order('name asc') }, class_name: "Category", foreign_key: :parent_id, dependent: :destroy
  has_many :product_categories, dependent: :destroy
  has_many :products, through: :product_categories
  has_many :size_guides
  has_many :products_containers, dependent: :destroy

  belongs_to :parent_category, class_name: "Category", foreign_key: :parent_id

  mount_uploader :image, CategoryUploader
  mount_uploader :icon, CategoryUploader

  @@bb_cat_map = {}

  def self.all_leaf_children(c, results = [])
    if c.subcategories.empty?
      if c.id >= IN_USED_CATEGORY_START_ID
        results << c
      end
      results
    else
      c.subcategories.each do |s|
        Category::all_leaf_children(s, results)
      end
      results
    end
  end

  def full_name
    names = []
    cat = self
    loop do
      names << cat.name
      cat = cat.parent_category
      break unless cat.present?
    end
    names.uniq.reverse.join(' > ')
  end

  def self.list_display_categories(only_trained = false)
    cache_key = only_trained ? 'cms_trained_display_categories' : 'cms_display_categories'
    roots = Rails.cache.read(cache_key)
    return roots unless roots.nil?

    # eagerly fetch all categories to build the tree
    all_categories = Category.where('id != ?', QUARANTINE_CATEGORY_ID).order(:name)
    id_to_entity = {}
    all_categories.each { |category| id_to_entity[category.id] = category }

    # find all leaf nodes
    all_leafs = []
    all_categories.each do |cat|
      if Category::is_leaf_node(cat, all_categories)
        all_leafs << cat
      end
    end

    root_id_to_dto = {}
    roots = []
    all_leafs.each do |leaf|
      next if leaf.id < IN_USED_CATEGORY_START_ID
      chain_to_root = Category::build_chain_to_root(leaf, id_to_entity)
      chain_to_root.reverse!

      root = chain_to_root.first
      next if root.id == QUARANTINE_CATEGORY_ID

      root_dto = root_id_to_dto[root.id]
      if root_dto.blank?
        root_dto = CategoryDto.new(root.id, root.name, nil)
        roots << root_dto
        root_id_to_dto[root.id] = root_dto
      end

      root_dto.subcategories << CategoryDto.new(leaf.id, chain_to_root.map { |c| c.name }.uniq.join(' > '), leaf.parent_id)
    end

    roots = roots.sort_by { |e| [e.name] }
    roots.each do |root_node|
      root_node.set_subcategories(root_node.subcategories.sort_by { |e| [e.parent_id, e.name] })
    end

    Rails.cache.write(cache_key, roots, time_to_idle: 1.hours, timeToLive: 3.hours)

    roots
  end

  def self.ulab_vision_excluded_cat_ids
    # Get id of sub categories of beauty category
    category_tree = Category::list_display_categories
    Category::flatten_categories(category_tree.detect { |ct| ct.id != MAN_CATEGORY_ID && ct.id != WOMAN_CATEGORY_ID }).map { |cat| cat[:id] }
  end

  def self.bb_vision_excluded_cat_ids
    # Get id of categories, imaging_category is blank
    Category.where(imaging_category: nil).order(:id).map { |cat| cat.id }
  end

  def self.bb_gender(cat_id)
    if @@bb_cat_map.blank?
      @@bb_cat_map = {}
      category_tree = Category::list_display_categories

      Category::flatten_categories(category_tree.detect { |ct| ct.id == MAN_CATEGORY_ID }).each { |cat|
        @@bb_cat_map[cat[:id]] = 'Men'
      }
      Category::flatten_categories(category_tree.detect { |ct| ct.id == WOMAN_CATEGORY_ID }).each { |cat|
        @@bb_cat_map[cat[:id]] = 'Women'
      }
    end

    @@bb_cat_map[cat_id]
  end

  private

  def self.is_leaf_node(cat, all_categories)
    all_categories.each do |other|
      if other.parent_id == cat.id
        return false
      end
    end
    true
  end

  def self.build_chain_to_root(cat, id_to_entity)
    chain = [cat]

    tmp = cat
    until tmp.parent_id.blank?
      tmp = id_to_entity[tmp.parent_id]
      chain << tmp
    end
    chain
  end

  def self.build_sub_category_name(sub_entity, name_arr, add_intermediate_level = true)
    entity = sub_entity
    prev_level_name = ''
    while !entity.level.nil? && entity.level > 1
      if entity.name != prev_level_name
        if name_arr.empty? || add_intermediate_level
          name_arr.insert(0, entity.name)
        end
        prev_level_name = entity.name
      end
      entity = entity.parent_category
    end
    entity
  end

  def self.flatten_categories(cat, results = [])
    results.push(Category::flatten_category(cat))
    cat.subcategories.each { |sub_cat| Category::flatten_categories(sub_cat, results) }
    results
  end

  def self.flatten_category(cat)
    {
        id: cat.id,
        name: cat.name,
        parent_id: cat.parent_id
    }
  end
end

class CategoryDto
  def initialize(id, name, parent_id)
    @id = id
    # full name
    @name = name
    @parent_id = parent_id
    @subcategories = []
  end

  def id
    @id
  end

  def name
    @name
  end

  def parent_id
    @parent_id
  end

  def subcategories
    @subcategories
  end

  def set_subcategories(subs)
    @subcategories = subs
  end

  def full_name
    name
  end
end