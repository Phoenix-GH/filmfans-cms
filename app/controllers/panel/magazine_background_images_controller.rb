class Panel::MagazineBackgroundImagesController < Panel::CustomizablePicturesController
  private
  def set_picture
    @picture = MagazineBackgroundImage.find(params[:id])
  end
end