class Panel::UpdateSocialCategoryService
  def initialize(social_category, form)
    @social_category = social_category
    @form = form
  end

  def call
    return false unless @form.valid?
    update
  end

  private

  def update
    @social_category.update_attributes(@form.attributes)
  end
end
