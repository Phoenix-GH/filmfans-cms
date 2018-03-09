class Panel::AdminsController < Panel::BaseController
  before_action :set_admin, only: [:edit, :update, :destroy, :toggle_active]

  def index
    authorize! :read, Admin
    @admins = AdminQuery.new(admin_search_params).results
  end

  def new
    authorize! :create, Admin
    @presenter = AdminPresenter.new(current_admin)
    @form = Panel::SendAdminInvitationForm.new({}, current_admin)
  end

  def create
    authorize! :create, Admin
    @presenter = AdminPresenter.new(current_admin)
    @form = Panel::SendAdminInvitationForm.new(admin_invitation_form_params, current_admin)
    service = Panel::SendAdminInvitationService.new(current_admin, @form)

    if service.call
      redirect_to panel_admins_path, notice: _('Admin was successfully invited')
    else
      render 'new'
    end
  end

  def edit
    authorize! :update, @admin
    @presenter = AdminPresenter.new(current_admin)
    @form = Panel::UpdateAdminForm.new(current_admin, admin_attributes)
  end

  def update
    authorize! :update, @admin
    @presenter = AdminPresenter.new(current_admin)
    @form = Panel::UpdateAdminForm.new(current_admin, admin_attributes, update_admin_form_params)
    service = Panel::UpdateAdminService.new(@admin, @form)

    if service.call
      redirect_to panel_admins_path, notice: _('Admin was successfully updated')
    else
      render 'edit'
    end
  end

  def toggle_active
    authorize! :update, @admin

    service = Panel::ToggleService.new(@admin, :active)
    service.call

    respond_to do |format|
      format.js do
        render layout: false
      end
    end

  end

  def destroy
    authorize! :destroy, @admin

    unless @admin.role == Role::SuperAdmin
      @admin.destroy
    else
      flash.alert = _('Cannot remove superadmin')
    end

    redirect_to panel_admins_path, notice: _('Admin was successfully deleted.')
  end

  private
  def set_admin
    @admin = Admin.find(params[:id])
  end

  def admin_search_params
    params.permit(:sort, :direction, :search, :role)
  end

  def admin_invitation_form_params
    params.require(:panel_send_admin_invitation_form).permit(
        :email,
        :role,
        channel_ids: [],
        media_owner_ids: []
    )
  end

  def update_admin_form_params
    params.require(:panel_update_admin_form).permit(
        :role,
        :active,
        channel_ids: [],
        media_owner_ids: []
    )
  end

  def admin_attributes
    @admin.slice('channel_ids', 'media_owner_ids', 'role', 'active')
  end

  def sort_column
    ['email', 'role', 'active'].include?(params[:sort]) ? params[:sort] : 'id'
  end
end
