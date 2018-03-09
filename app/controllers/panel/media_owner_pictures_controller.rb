class Panel::MediaOwnerPicturesController < Panel::CustomizablePicturesController
  private
  def set_picture
    @picture = MediaOwnerPicture.find(params[:id])
  end
end