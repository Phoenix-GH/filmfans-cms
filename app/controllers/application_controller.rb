class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_gettext_locale

  def set_gettext_locale
    requested_locale = request.headers['locale'] || I18n.default_locale
    params[:locale] = requested_locale
    super
  end

  def after_sign_in_path_for(resource)
    panel_root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:ulab_user_id, :ulab_access_token]
    devise_parameter_sanitizer.for(:account_update)
  end
end