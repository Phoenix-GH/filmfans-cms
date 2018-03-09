class Panel::UpdateTvShowService
  attr_reader :tv_show

  def initialize(tv_show, form)
    @tv_show = tv_show
    @form = form
  end

  def call
    return false unless @form.valid?

    update_tv_show

  end

  private

  def update_tv_show
    @tv_show.update_attributes(@form.attributes)
    @tv_show.cover_image.update_attributes(@form.cover_image_attributes)
    @tv_show.background_image.update_attributes(@form.background_image_attributes)
  end
end
