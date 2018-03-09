class Panel::ManualPostImageController < Panel::CustomizablePicturesController
  private

  def picture_file
    @picture.image
  end

  def set_picture
    @picture = ManualPost.find(params[:id])
  end
end