class Admin < ActiveRecord::Base
  include ClassyEnum::ActiveRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :registerable, :rememberable
  devise :invitable, :database_authenticatable,
    :recoverable, :trackable, :validatable

  has_many :channel_moderators, dependent: :destroy
  has_many :channels, through: :channel_moderators
  has_many :media_owner_moderators, dependent: :destroy
  has_many :media_owners, through: :media_owner_moderators

  has_many :collections
  has_many :collections_containers
  has_many :events
  has_many :events_containers
  has_many :products_containers

  classy_enum_attr :role, default: "admin"

  def channel_ids
    if role > Role::Moderator
      Channel.all.pluck(:id) + [nil]
    else
      super
    end
  end

  def media_owner_ids
    if role > Role::Moderator
      MediaOwner.all.pluck(:id) + [nil]
    else
      super
    end
  end

  def active_for_authentication?
    super && active
  end

  def owners_count
    channels.count + media_owners.count
  end
end
