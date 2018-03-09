class Panel::ChannelPicturesController < Panel::CustomizablePicturesController
  private
  def set_picture
    @picture = ChannelPicture.find(params[:id])
  end
end