class Panel::IssueCoverImagesController < Panel::CustomizablePicturesController
  private
  def set_picture
    @picture = IssueCoverImage.find(params[:id])
  end
end