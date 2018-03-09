class Ability
  include CanCan::Ability

  def initialize(admin)
    admin ||= admin.new # guest admin (not logged in)
    if admin.role >= Role::Admin
      can :manage, :all

      cannot [:destroy, :update], Admin do |object|
        object.role > admin.role
      end
    else
      #Admin
      cannot [:read, :create, :destroy, :update], Admin

      #Home
      cannot [:read, :create, :destroy, :update], Home

      #Collection
      if admin.role == Role::Moderator
        can [:create], Collection
        can [:read, :update, :destroy], Collection do |object|
          object.admin_id == admin.id
        end
      else
        cannot [:read, :create, :destroy, :update], Collection
      end

      #CollectionsContainer
      if admin.role == Role::Moderator
        can [:create], CollectionsContainer
        can [:read, :update, :destroy], CollectionsContainer do |object|
          object.admin_id == admin.id
        end
      else
        cannot [:read, :create, :destroy, :update], CollectionsContainer
      end

      #Event
      if admin.role == Role::Moderator
        can [:create], Event
        can [:read, :update, :destroy], Event do |object|
          object.admin_id == admin.id
        end
      else
        cannot [:read, :create, :destroy, :update], Event
      end

      #EventsContainer
      if admin.role == Role::Moderator
        can [:create], EventsContainer
        can [:read, :update, :destroy], EventsContainer do |object|
          object.admin_id == admin.id
        end
      else
        cannot [:read, :create, :destroy, :update], EventsContainer
      end

      #MediaContainer
      can [:create], MediaContainer
      can [:read, :update, :destroy], MediaContainer do |object|
        (admin.channel_ids.include?(object.owner_id) && object.owner_type == 'Channel') ||
          (admin.media_owner_ids.include?(object.owner_id) && object.owner_type == 'MediaOwner')
      end

      #ProductsContainer
      can [:create], ProductsContainer
      can [:read, :update, :destroy], ProductsContainer do |object|
        object.admin_id == admin.id
      end

      #MediaOwner
      can [:read, :create, :update, :destroy], MediaOwner do |object|
        admin.media_owner_ids.include?(object.id)
      end

      #Channel
      if admin.role == Role::Moderator
        can [:read, :create, :update, :destroy], Channel do |object|
          admin.channel_ids.include?(object.id)
        end
      else
        cannot [:read, :create, :destroy, :update], Channel
      end

      #Category
      can [:read], Category
      cannot [:create, :update, :destroy], Category

      #Product
      can [:read], Product
      cannot [:create, :destroy, :update], Product
    end
  end
end
