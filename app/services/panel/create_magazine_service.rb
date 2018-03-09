class Panel::CreateMagazineService
  attr_reader :magazine

  def initialize(form, user)
    @form = form
    @user = user
  end

  def call
    return false unless @form.valid?

    ActiveRecord::Base.transaction do
      create_magazine
      create_cover_image
      create_background_image
    end
  end

  private

  def create_magazine
    @magazine = Magazine.create(@form.attributes)
    # so that it will be displayed on top
    @magazine.position = @magazine.id
    @magazine.save
  end

  def create_cover_image
    @magazine.create_cover_image(@form.cover_image_attributes)
  end

  def create_background_image
    @magazine.create_background_image(@form.background_image_attributes)
  end
end
