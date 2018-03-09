class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, password_length: 6..128
  include DeviseTokenAuth::Concerns::User

  has_many :addresses
  has_many :followings, dependent: :destroy
  has_many :snapped_photos
  has_many :snapped_products
  has_many :photographed_products, through: :snapped_products, source: :product
  has_many :wishlists, dependent: :destroy
  has_many :saved_products, through: :wishlists, source: :product
  has_many :media_owners,
    through: :followings,
    source: :followed,
    source_type: 'MediaOwner'

  has_many :channels,
    through: :followings,
    source: :followed,
    source_type: 'Channel'

  has_one :profile

  has_many :social_user_followees, dependent: :destroy
  has_many :social_account_followings, through: :social_user_followees

  def devise_mailer
    UserMailer
  end

  def is_following?(followed)
    if followed.class.to_s == 'MediaOwner' || followed.class.to_s == 'Channel'
      followings.where(followed_id: followed.id, followed_type: followed.class.to_s).present?
    end
  end

  def allow_password_change
    @allow_password_change || true
  end

  def is_wishing?(product_id)
    wishlists.where(product_id: product_id).present?
  end

  def token_validation_response
    as_json(except: [
        :tokens, :created_at, :updated_at
      ]).merge(ProfileSerializer.new(profile).results)
      .merge(addresses: addresses_serialize)
  end

  def addresses_serialize
    addresses.map do |res|
      AddressSerializer.new(res).results
    end
  end
end
