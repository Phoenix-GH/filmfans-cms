class Panel::UpdateSocialFollowingCategoriesForm
  include ActiveModel::Model

  attr_accessor(
      :social_category_ids
  )

  def initialize(attrs, form_attrs = {})
    super attrs.merge(form_attrs)
  end

  def attributes
    {
        social_category_ids: social_category_ids
    }
  end
end
