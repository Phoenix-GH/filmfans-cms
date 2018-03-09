class Panel::CategoriesController < Panel::BaseController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    get_all_categories
    Rails.cache.delete('cms_display_categories')
    Rails.cache.delete('cms_trained_display_categories')
    Rails.cache.delete('apps_display_categories')
    Rails.cache.delete('categories_for_apps_merchandise')
  end

  def untrained
    product_counts_by_cat = count_products_by_cat
    categories = Category.where('level = 3 and imaging_category is null')

    @total_product = 0
    name_to_cat_map = {}

    categories.each do |cat|
      count = product_counts_by_cat[cat.id].to_i
      @total_product += count

      c = name_to_cat_map[cat[:name]]
      if c.nil?
        c = {
            top_name: get_top_category_name(cat),
            name: cat.name,
            product_count: count
        }
        name_to_cat_map[c[:name]] = c
      else
        c[:top_name] = 'Unisex'
        c[:product_count] += count
      end
    end

    @untrained_categories = []
    name_to_cat_map.each do |key, value|
      next if value[:product_count].nil? or value[:product_count] == 0
      value[:name] = "#{value[:top_name]} > #{value[:name]}"
      @untrained_categories << value
    end

    @sort_column = untrained_params[:sort] || 'products'
    @sort_direction = untrained_params[:direction] || 'desc'

    if @sort_direction == 'asc'
      @untrained_categories = @untrained_categories.sort_by { |c|
        @sort_column == 'products' ? c[:product_count] : c[:name]
      }
    else
      @untrained_categories = @untrained_categories.sort_by { |c|
        @sort_column == 'products' ? c[:product_count] : c[:name]
      }.reverse
    end
  end

  def show
    @categories = CategoryQuery.new(
        category_search_params.merge(parent_id: @category.id)
    ).results
  end

  def new
    authorize! :create, Category
    @form = Panel::CreateCategoryForm.new
  end

  def create
    authorize! :create, Category
    @form = Panel::CreateCategoryForm.new(category_form_params)
    service = Panel::CreateCategoryService.new(@form)

    if service.call
      redirect_to panel_categories_path, notice: _('Category was successfully created.')
    else
      render :new
    end
  end

  def edit
    authorize! :update, @category
    @form = Panel::UpdateCategoryForm.new(category_attributes)
  end

  def update
    authorize! :update, @category
    @form = Panel::UpdateCategoryForm.new(
        category_attributes,
        category_form_params
    )
    service = Panel::UpdateCategoryService.new(@category, @form)

    if service.call
      redirect_to panel_category_path, notice: _('Category was successfully updated.')
    else
      render :edit
    end
  end

  private
  def set_category
    @category = Category.find(params[:id])
  end

  def category_attributes
    @category.slice('parent_id', 'name', 'icon', 'image')
  end

  def category_form_params
    params.require(:category_form).permit(:parent_id, :name, :icon, :image)
  end

  def category_search_params
    params.permit(:sort, :direction, :search)
  end

  def sort_column
    ['name'].include?(params[:sort]) ? params[:sort] : 'name'
  end

  def get_all_categories
    @category_tree_models = []
    @id_to_tree_model = {}

    product_counts_by_cat = count_products_by_cat

    @leaf_categories = []
    level = 1
    begin
      cats = query_categories("(id >= 50 or id = 40 or id = 41) and level = #{level}")
      add_js_tree_models(product_counts_by_cat, cats)
      break if cats.blank?
      level += 1
    end while true

    @category_tree_models.each { |top_node|
      product_count = sum_products(top_node)
      top_node[:tags] << product_count if product_count > 0
    }

    @total_product = ProductCategory.where.not(category_id: 48).distinct.count('product_id')
  end

  def count_products_by_cat
    ProductCategory
        .where
        .not(category_id: 48)
        .group(:category_id)
        .count
  end

  def query_categories(sql)
    Category.includes(:subcategories, :parent_category).where(sql).order('name asc')
  end

  def sum_products(node)
    return (node[:product_count] || 0) if node[:nodes].blank?

    total = node[:product_count] || 0
    node[:nodes].each { |n|
      total += sum_products(n)
    }
    total
  end

=begin
  {
    text: "Node 1",
    icon: "glyphicon glyphicon-stop",
    selectedIcon: "glyphicon glyphicon-stop",
    color: "#000000",
    backColor: "#FFFFFF",
    href: "#node-1",
    selectable: true,
    state: {
      checked: true,
      disabled: true,
      expanded: true,
      selected: true
    },
    tags: ['available'],
    nodes: [
      {},
      ...
    ]
  }
=end
  def add_js_tree_models(product_counts_by_cat, categories)
    categories.each { |cat|
      if cat.subcategories.blank?
        @leaf_categories << cat
      end

      if cat.parent_category.nil?
        model = new_node_model
        model[:state] = {
            expanded: false
        }
        @category_tree_models << model
        fill_node_model(model, cat, product_counts_by_cat)
      else
        parent = @id_to_tree_model[cat.parent_category.id]

        if parent[:text] == cat.name && cat.parent_category.subcategories.size == 1
          fill_node_model(parent, cat, product_counts_by_cat)
        else
          parent[:nodes] = [] if parent[:nodes].nil?
          model = new_node_model
          fill_node_model(model, cat, product_counts_by_cat)
          parent[:nodes] << model
        end
      end
    }
  end

  def new_node_model
    {
        tags: [],
        selectable: false
    }
  end

  def fill_node_model(model, cat, product_counts_by_cat)
    @id_to_tree_model[cat.id] = model
    product_count = product_counts_by_cat[cat.id]

    model[:text] = cat.name
    unless product_count.blank?
      model[:tags] << product_count.to_s
      model[:product_count] = product_count
    end

    if cat.parent_category.nil?
      model[:color] = '#ffffff'
      model[:backColor] = "#428bca"
    elsif cat.subcategories.empty?
      model[:tags] << 'hidden' if cat.hidden
      model[:tags] << 'trained' unless cat.imaging_category.blank?
    end
  end

  def get_top_category_name cat
    if cat.parent_category.nil?
      return cat.name
    end
    get_top_category_name cat.parent_category
  end

  def untrained_params
    params.permit(:sort, :direction)
  end

  def sort_direction
    @sort_direction
  end

  def sort_column
    @sort_column
  end
end
