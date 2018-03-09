class Panel::UpdateSocialAccountForm < Panel::BaseSocialAccountForm
  def initialize(attributes, form_attributes = {})
    super attributes.merge(form_attributes)
  end
end
