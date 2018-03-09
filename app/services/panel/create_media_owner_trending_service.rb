class Panel::CreateMediaOwnerTrendingService

  def initialize(form)
    @form = form
  end

  def call
    return false unless @form.valid?

    create_media_owner_trending
  end

  private

  def create_media_owner_trending
    ManualPost.create(@form.attributes)
  end

end