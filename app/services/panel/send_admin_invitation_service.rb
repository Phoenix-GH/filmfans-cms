class Panel::SendAdminInvitationService
  def initialize(current_admin, form)
    @current_admin = current_admin
    @form = form
  end

  def call
    return false unless @form.valid?

    send_invitation_to_admin
  end

  private

  def send_invitation_to_admin
    @admin = Admin.invite!(@form.attributes, @current_admin)
  end
end
