class Panel::UpdateCategoryService
  def initialize(category, form)
    @category = category
    @form = form
  end

  def call
    return false unless @form.valid?

    update_category
  end

  private

  def update_category
    @category.update_attributes(@form.category_attributes)
  end
end