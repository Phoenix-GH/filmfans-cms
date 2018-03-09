class AdminPresenter
  def initialize(user)
    @user = user
  end

  def channel_countries
    countries = [['Global', Country::CODE_GLOBAL]]

    Country.order(:name).each { |country|
      countries << [country.name, country.code]
    }

    countries
  end

  def role_options
    Role.select { |role| role <= @user.role }.map { |role| [role.text, role.to_s] }
  end

  def channel_options
    channels.map { |channel| [channel.name, channel.id] }
  end

  def media_owner_options
    media_owners.map { |media_owner| [media_owner.name, media_owner.id] }
  end

  def owner_options
    c = channels.map { |channel| [channel.name, "Channel:#{channel.id}"] }
    mo = media_owners.map { |media_owner| [media_owner.name, "MediaOwner:#{media_owner.id}"] }
    c + mo
  end

  def channels
    if @user.role > Role::Moderator
      Channel.order(:name)
    else
      Channel.where(id: @user.channel_ids).order(:name)
    end
  end

  def media_owners
    if @user.role > Role::Moderator
      MediaOwner.order(:name)
    else
      MediaOwner.where(id: @user.media_owner_ids).order(:name)
    end
  end
end
