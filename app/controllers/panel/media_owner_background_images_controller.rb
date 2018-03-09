class Panel::MediaOwnerBackgroundImagesController < Panel::CustomizablePicturesController
  private
  def set_picture
    @picture = MediaOwnerBackgroundImage.find(params[:id])
  end
end