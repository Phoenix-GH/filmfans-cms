class Panel::BaseSocialAccountForm
  include ActiveModel::Model

  attr_accessor(
      :name, :username, :password, :provider
  )

  validates :name, :username, :password, presence: true
  validates :provider, social_account: true
  validates :password, confirmation: true

  def attributes
    {
        name: name,
        username: username,
        password: CryptoHelper.encrypt(password),
        provider: provider
    }
  end
end
