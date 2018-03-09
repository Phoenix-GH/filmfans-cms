class Panel::UpdateSocialAccountService
  def initialize(social_account, form)
    @social_account = social_account
    @form = form
  end

  def call
    return false unless @form.valid?
    update
  end

  private

  def update
    @social_account.update_attributes(@form.attributes)
  end
end
