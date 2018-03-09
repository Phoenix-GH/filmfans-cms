class Panel::CustomizablePicturesController < Panel::BaseController
  before_filter :set_picture, only: [:update]

  def update
    @picture.update_attributes(picture_params)
    picture_file.recreate_versions!
    render 'shared/file', layout: false
  end

  private
  def picture_file
    @picture.file
  end

  def picture_params
    params.require(:picture).permit(specification: [:crop_x, :crop_y, :width, :height, :zoom, :cropBox_x, :cropBox_y, :cropBox_width, :cropBox_height])
  end
end
