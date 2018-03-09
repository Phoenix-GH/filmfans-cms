class Panel::TvShowBackgroundImagesController < Panel::CustomizablePicturesController
  private
  def set_picture
    @picture = TvShowBackgroundImage.find(params[:id])
  end
end