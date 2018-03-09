class Panel::CreateSocialCategoryService
  def initialize(form)
    @form = form
  end

  def call
    return false unless @form.valid?
    create
  end

  private
  def create
    SocialCategory.create(@form.attributes)
  end
end