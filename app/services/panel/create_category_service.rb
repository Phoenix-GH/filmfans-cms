class Panel::CreateCategoryService
  def initialize(form)
    @form = form
  end

  def call
    return false unless @form.valid?

    create_category
  end

  private

  def create_category
    Category.create(@form.category_attributes)
  end
end
