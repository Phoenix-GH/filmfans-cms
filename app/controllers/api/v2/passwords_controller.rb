class Api::V2::PasswordsController < DeviseTokenAuth::PasswordsController

  DEFAULT_REDIRECT_ON_ERROR_URL = 'http://hotspotting.com/reset-password-error.html'
  DEFAULT_REDIRECT_ON_INCORRECT_PLATFORM_URL = 'http://hotspotting.com/incorrect-platform.html'

  # this is where users arrive after visiting the password reset confirmation link
  def edit
    if is_mobile_device?
      super
    else
      render_platform_incorrect
    end
    Rails.logger.info "User agent: #{request.user_agent}"
  end

  protected
  def render_edit_error
    render_error
  end

  def render_update_error
    render_error
  end

  private
  def is_mobile_device?
    request.user_agent =~ /Mobile|webOS/
  end

  def render_error
    redirect_to DEFAULT_REDIRECT_ON_ERROR_URL
  end

  def render_platform_incorrect
    redirect_to DEFAULT_REDIRECT_ON_INCORRECT_PLATFORM_URL
  end
end