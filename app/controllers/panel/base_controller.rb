class Panel::BaseController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_admin!
  layout 'panel'

  helper_method :sort_column, :sort_direction
  helper_method :supported_languages, :supported_languages

  alias_method :current_user, :current_admin

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: _("You are not authorized to perform this action.")
  end

  def supported_languages
    Translation.supported_langs = SupportedLanguageQuery.instance.all_langs.map(&:code)
  end

  private
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
