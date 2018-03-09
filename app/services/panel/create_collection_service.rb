class Panel::CreateCollectionService
  attr_reader :collection

  def initialize(form, user)
    @form = form
    @user = user
  end

  def call
    return false unless @form.valid?

    create_collection
    create_background_image
    create_cover_image
    add_admin_id
  end

  private

  def create_collection
    @collection = Collection.create(@form.collection_attributes)
  end

  def create_background_image
    @collection.create_background_image(@form.background_image_attributes)
  end

  def create_cover_image
    @collection.create_cover_image(@form.cover_image_attributes)
  end

  def add_admin_id
    if @user.role == 'moderator'
      @collection.update_attributes(admin_id: @user.id)
    end

    true
  end
end
