class Api::V1::SnappedPhotosController < Api::V1::BaseController
  before_action :authenticate_api_v1_user!, only: [:index, :create, :destroy, :delete_multi]
  before_action :set_snapped_photo, only: [:destroy]

  def index
    user_snapped_photos = current_api_v1_user.snapped_photos.order('created_at desc')

    render json: user_snapped_photos.map { |snapped_photo|
      SnappedPhotoSerializer.new(snapped_photo).results
    }
  end

  def create
    encoded_image = image_params[:image].to_s
    SaveSnappedPhotoWorker.perform_async(current_api_v1_user.id, encoded_image)

    render nothing: true, status: 200
  end

  def destroy
    @snapped_photo.destroy
    render nothing: true, status: 200
  end

  def delete_multi
    unless params[:ids].nil? || params[:ids].empty?
      params[:ids].each do |id|
        current_api_v1_user.snapped_photos.find(id).destroy
      end
    end
    render nothing: true, status: 200
  end

  private
  def image_params
    params.permit(:image)
  end

  def set_snapped_photo
    @snapped_photo = current_api_v1_user.snapped_photos.find(params[:id])
  end

end
