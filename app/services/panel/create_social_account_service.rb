class Panel::CreateSocialAccountService
  def initialize(form)
    @form = form
  end

  def call
    return false unless @form.valid?
    create
  end

  private
  def create
    SocialAccount.create(@form.attributes)
  end
end