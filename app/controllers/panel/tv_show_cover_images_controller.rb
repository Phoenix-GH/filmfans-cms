class Panel::TvShowCoverImagesController < Panel::CustomizablePicturesController
  private
  def set_picture
    @picture = TvShowCoverImage.find(params[:id])
  end
end