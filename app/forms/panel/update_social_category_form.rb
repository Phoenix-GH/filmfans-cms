class Panel::UpdateSocialCategoryForm < Panel::BaseSocialCategoryForm
  def initialize(attributes, form_attributes = {})
    super attributes.merge(form_attributes)
  end
end
