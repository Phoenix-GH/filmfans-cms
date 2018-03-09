class Panel::Wizards::CreateProductCategoryService
  def initialize(product, category_ids = [])
    @product = product
    @category_ids = category_ids
  end

  def call
    ActiveRecord::Base.transaction do
      remove_old_product_categories
      create_new_product_categories
    end
  end

  private

  def remove_old_product_categories
    ProductCategory.where(product: @product).delete_all
  end

  def create_new_product_categories
    @category_ids.each do |id|
      category = Category.find_by(id: id)
      if category
        ProductCategory.create(product: @product, category: category, manual: true)
      end
    end
  end
end
