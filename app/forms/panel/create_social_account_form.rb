class Panel::CreateSocialAccountForm < Panel::BaseSocialAccountForm
  validate :uniqueness

  private
  def uniqueness
    if SocialAccount.exists?(username: username, provider: provider)
      errors[:username] << "#{provider.titleize} account with username [#{username}] has already existed"
    end
  end
end
