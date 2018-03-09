class Panel::CreateTvShowService
  attr_reader :tv_show

  def initialize(form, user)
    @form = form
    @user = user
  end

  def call
    return false unless @form.valid?

    ActiveRecord::Base.transaction do
      create_tv_show
      create_cover_image
      create_background_image
    end
  end

  private

  def create_tv_show
    @tv_show = TvShow.create(@form.attributes)
    # so that it will be displayed on top
    @tv_show.position = @tv_show.id
    @tv_show.save
  end

  def create_cover_image
    @tv_show.create_cover_image(@form.cover_image_attributes)
  end

  def create_background_image
    @tv_show.create_background_image(@form.background_image_attributes)
  end
end
