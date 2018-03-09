class Panel::UpdateMagazineService
  attr_reader :magazine

  def initialize(magazine, form)
    @magazine = magazine
    @form = form
  end

  def call
    return false unless @form.valid?

    update_magazine
  end

  private

  def update_magazine
    @magazine.update_attributes(@form.attributes)

    unless @form.cover_image_attributes.blank?
      @magazine.cover_image.update_attributes(@form.cover_image_attributes)
      @magazine.background_image.update_attributes(@form.background_image_attributes)
    end

    true
  end
end
