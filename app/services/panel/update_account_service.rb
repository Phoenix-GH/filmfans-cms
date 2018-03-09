class Panel::UpdateAccountService
  def initialize(admin, form)
    @admin = admin
    @form = form
  end

  def call
    return false unless @form.valid?

    update_account
  end

  private

  def update_account
    @admin.update_attributes(@form.account_attributes)
  end
end
