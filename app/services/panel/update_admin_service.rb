class Panel::UpdateAdminService
  def initialize(admin, form)
    @admin = admin
    @form = form
  end

  def call
    return false unless @form.valid?

    update_admin
  end

  private

  def update_admin
    @admin.update_attributes(@form.attributes)
  end
end
