class Panel::SettingsController < Panel::BaseController
  def index
    @form = Panel::UpdateAccountForm.new(account_attributes)
  end

  def update_account
    @form = Panel::UpdateAccountForm.new(account_attributes, account_form_params)
    service = Panel::UpdateAccountService.new(current_admin, @form)

    if service.call
      redirect_to panel_settings_path, notice: _('Your account was successfully updated.')
    else
      render :index
    end
  end

  def reset_password
    current_admin.send_reset_password_instructions
    redirect_to panel_settings_path, notice: _('Reset password instructions have been send to your email address.')
  end

  def delete_account
    current_admin.destroy
    redirect_to root_path
  end

  private

  def account_attributes
    current_admin.slice('full_name', 'email')
  end

  def account_form_params
    params.require(:account_form).permit(:full_name, :email)
  end
end
