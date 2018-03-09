describe Ability do
  context "when is SuperAdmin" do
    let(:admin) { create(:admin, role: Role::SuperAdmin) }
    subject(:ability){ Ability.new(admin) }

    #Admin
    it{ is_expected.to be_able_to(:update, create(:admin, role: Role::SuperAdmin)) }
    it{ is_expected.to be_able_to(:destroy, create(:admin, role: Role::SuperAdmin)) }
    it{ is_expected.to be_able_to(:update, create(:admin, role: Role::Admin)) }
    it{ is_expected.to be_able_to(:destroy, create(:admin, role: Role::Admin)) }
    it{ is_expected.to be_able_to(:update, create(:admin, role: Role::Moderator)) }
    it{ is_expected.to be_able_to(:destroy, create(:admin, role: Role::Moderator)) }

    [:create, :read, :update, :destroy].each do |action|
      it{ is_expected.to be_able_to(action, build(:collections_container)) }
      it{ is_expected.to be_able_to(action, build(:media_container)) }
      it{ is_expected.to be_able_to(action, build(:products_container)) }
      it{ is_expected.to be_able_to(action, build(:collection)) }
      it{ is_expected.to be_able_to(action, build(:category)) }
      it{ is_expected.to be_able_to(action, build(:product)) }
      it{ is_expected.to be_able_to(action, build(:home)) }
      it{ is_expected.to be_able_to(action, build(:media_owner)) }
      it{ is_expected.to be_able_to(action, build(:channel)) }
    end
  end

  context "when is Admin" do
    let(:admin) { create(:admin, role: Role::Admin) }
    subject(:ability){ Ability.new(admin) }

    #Admin
    it{ is_expected.not_to be_able_to(:update, create(:admin, role: Role::SuperAdmin)) }
    it{ is_expected.not_to be_able_to(:destroy, create(:admin, role: Role::SuperAdmin)) }
    it{ is_expected.to be_able_to(:update, create(:admin, role: Role::Admin)) }
    it{ is_expected.to be_able_to(:destroy, create(:admin, role: Role::Admin)) }
    it{ is_expected.to be_able_to(:update, create(:admin, role: Role::Moderator)) }
    it{ is_expected.to be_able_to(:destroy, create(:admin, role: Role::Moderator)) }

    [:create, :read, :update, :destroy].each do |action|
      it{ is_expected.to be_able_to(action, build(:collections_container)) }
      it{ is_expected.to be_able_to(action, build(:media_container)) }
      it{ is_expected.to be_able_to(action, build(:products_container)) }
      it{ is_expected.to be_able_to(action, build(:collection)) }
      it{ is_expected.to be_able_to(action, build(:category)) }
      it{ is_expected.to be_able_to(action, build(:product)) }
      it{ is_expected.to be_able_to(action, build(:home)) }
      it{ is_expected.to be_able_to(action, build(:media_owner)) }
      it{ is_expected.to be_able_to(action, build(:channel)) }
    end
  end

  context "when is Moderator" do
    let(:channel) { create(:channel) }
    let(:media_owner) { create(:media_owner) }
    let(:admin) { create(
      :admin,
      role: Role::Moderator,
      channel_ids: [channel.id],
      media_owner_ids: [media_owner.id]
    ) }
    subject(:ability){ Ability.new(admin) }

    #Admin
    it{ is_expected.not_to be_able_to(:destroy, create(:admin, role: Role::SuperAdmin)) }
    it{ is_expected.not_to be_able_to(:destroy, create(:admin, role: Role::Admin)) }
    it{ is_expected.not_to be_able_to(:destroy, create(:admin, role: Role::Moderator)) }

    #CollectionsContainer
    it{ is_expected.to be_able_to(:create, build(:collections_container)) }
    it{ is_expected.not_to be_able_to(:read, build(:collections_container)) }
    it{ is_expected.to be_able_to(:read, build(:collections_container, admin_id: admin.id)) }
    it{ is_expected.not_to be_able_to(:update, build(:collections_container)) }
    it{ is_expected.to be_able_to(:update, build(:collections_container, admin_id: admin.id)) }
    it{ is_expected.not_to be_able_to(:destroy, build(:collections_container)) }
    it{ is_expected.to be_able_to(:destroy, build(:collections_container, admin_id: admin.id)) }

    #MediaContainer
    it{ is_expected.to be_able_to(:create, build(:media_container)) }
    it{ is_expected.not_to be_able_to(:read, build(:media_container)) }
    it{ is_expected.to be_able_to(:read, build(:media_container, owner: channel)) }
    it{ is_expected.to be_able_to(:read, build(:media_container, owner: media_owner)) }
    it{ is_expected.not_to be_able_to(:update, build(:media_container)) }
    it{ is_expected.to be_able_to(:update, build(:media_container, owner: channel)) }
    it{ is_expected.to be_able_to(:update, build(:media_container, owner: media_owner)) }
    it{ is_expected.not_to be_able_to(:destroy, build(:media_container)) }
    it{ is_expected.to be_able_to(:destroy, build(:media_container, owner: channel)) }
    it{ is_expected.to be_able_to(:destroy, build(:media_container, owner: media_owner)) }

    #ProductsContainer
    it{ is_expected.to be_able_to(:create, build(:products_container)) }
    it{ is_expected.not_to be_able_to(:read, build(:products_container)) }
    it{ is_expected.to be_able_to(:read, build(:products_container, admin_id: admin.id)) }
    it{ is_expected.not_to be_able_to(:update, build(:products_container)) }
    it{ is_expected.to be_able_to(:update, build(:products_container, admin_id: admin.id)) }
    it{ is_expected.not_to be_able_to(:destroy, build(:products_container)) }
    it{ is_expected.to be_able_to(:destroy, build(:products_container, admin_id: admin.id)) }

    #Collection
    it{ is_expected.to be_able_to(:create, build(:collection)) }
    it{ is_expected.not_to be_able_to(:read, build(:collection)) }
    it{ is_expected.to be_able_to(:read, build(:collection, admin_id: admin.id)) }
    it{ is_expected.not_to be_able_to(:update, build(:collection)) }
    it{ is_expected.to be_able_to(:update, build(:collection, admin_id: admin.id)) }
    it{ is_expected.not_to be_able_to(:destroy, build(:collection)) }
    it{ is_expected.to be_able_to(:destroy, build(:collection, admin_id: admin.id)) }

    #MediaOwner
    it{ is_expected.not_to be_able_to(:read, build(:media_owner)) }
    it{ is_expected.to be_able_to(:read, media_owner) }
    it{ is_expected.not_to be_able_to(:create, build(:media_owner)) }
    it{ is_expected.to be_able_to(:create, media_owner) }
    it{ is_expected.not_to be_able_to(:update, build(:media_owner)) }
    it{ is_expected.to be_able_to(:update, media_owner) }
    it{ is_expected.not_to be_able_to(:destroy, build(:media_owner)) }

    #Channel
    it{ is_expected.not_to be_able_to(:read, build(:channel)) }
    it{ is_expected.to be_able_to(:read, channel) }
    it{ is_expected.not_to be_able_to(:create, build(:channel)) }
    it{ is_expected.to be_able_to(:create, channel) }
    it{ is_expected.not_to be_able_to(:update, build(:channel)) }
    it{ is_expected.to be_able_to(:update, channel) }
    it{ is_expected.not_to be_able_to(:destroy, build(:channel)) }

    #Category
    it{ is_expected.to be_able_to(:read, build(:category)) }
    it{ is_expected.not_to be_able_to(:create, build(:category)) }
    it{ is_expected.not_to be_able_to(:update, build(:category)) }
    it{ is_expected.not_to be_able_to(:destroy, build(:category)) }

    #Product
    it{ is_expected.to be_able_to(:read, build(:product)) }
    it{ is_expected.not_to be_able_to(:create, build(:product)) }
    it{ is_expected.not_to be_able_to(:update, build(:product)) }
    it{ is_expected.not_to be_able_to(:destroy, build(:product)) }

    #Home
    it{ is_expected.not_to be_able_to(:read, build(:home)) }
    it{ is_expected.not_to be_able_to(:create, build(:home)) }
    it{ is_expected.not_to be_able_to(:update, build(:home)) }
    it{ is_expected.not_to be_able_to(:destroy, build(:home)) }
  end
end
