class Panel::DestroyMediaContentService
  def initialize(media_content)
    @media_content = media_content
  end

  def call
    return false if first_media_content

    destroy_media_content
  end

  private

  def destroy_media_content
    @media_content.destroy
  end

  def first_media_content
    return false if @media_content.membership.blank?

    @media_content == @media_content.membership.media_content
  end
end
