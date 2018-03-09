class Panel::MagazineCoverImagesController < Panel::CustomizablePicturesController
  private
  def set_picture
    @picture = MagazineCoverImage.find(params[:id])
  end
end