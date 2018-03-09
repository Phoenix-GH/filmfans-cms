class Panel::UpdateAdminForm
  include ActiveModel::Model

  attr_accessor(
    :role, :channel_ids, :media_owner_ids, :active
  )

  validates :role, :active, presence: true
  validate :presence_channel_or_media_owner, if: :moderator?
  validate :privilege_to_assign_roles
  validate :privilege_to_assign_channel, if: :channel_ids?
  validate :privilege_to_assign_media_owner, if: :media_owner_ids?

  def initialize(user, admin_attrs, form_attributes = {})
    @user = user
    super admin_attrs.merge(form_attributes)
  end

  def attributes
    {
      role: role,
      channel_ids: channel_ids,
      media_owner_ids: media_owner_ids,
      active: active
    }
  end

  private
  def moderator?
    role == Role[:moderator].to_s
  end

  def channel_ids?
    channel_ids.present? && channel_ids.reject(&:blank?).present?
  end

  def media_owner_ids?
    media_owner_ids.present? && media_owner_ids.reject(&:blank?).present?
  end

  def privilege_to_assign_roles
    if @user.role < role
      errors[:role] << _("You can't assign this role")
    end
  end

  def presence_channel_or_media_owner
    unless channel_ids? || media_owner_ids?
      errors[:channel_ids] << _("You have to specific channels or media owners")
      errors[:media_owner_ids] << _("You have to specific channels or media owners")
    end
  end

  def privilege_to_assign_channel
    if @user.role == Role::Moderator && [channel_ids] != @user.channel_ids
      errors[:channel_ids] << _("You can't assign these channels")
    end
  end

  def privilege_to_assign_media_owner
    if @user.role == Role::Moderator && [media_owner_ids] != @user.media_owner_ids
      errors[:media_owner_ids] << _("You can't assign these medie owners")
    end
  end
end
