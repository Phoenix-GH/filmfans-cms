class Panel::ToggleFollowingForm
  include ActiveModel::Model

  attr_accessor(
    :user_id,
    :followed_id,
    :followed_type
  )

  validates :user_id, presence: true
  validate :followed_existence
  validate :followed_type_correctness

  def following_attributes
    {
      user_id: user_id,
      followed_id: followed_id,
      followed_type: followed_type
    }
  end

  private

  def followed_existence
    if followed_type == 'MediaOwner' && MediaOwner.find_by(id: followed_id).blank?
      errors[:base] << _("Media owner not found.")
    elsif followed_type == 'Channel' && Channel.find_by(id: followed_id).blank?
      errors[:base] << _("Channel not found.")
    end
  end

  def followed_type_correctness
    unless followed_type == 'MediaOwner' || followed_type == 'Channel'
      errors[:base] << _("Incorrect followed_type.")
    end
  end
end
