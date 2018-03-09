class Api::V1::SessionsController < Api::V1::BaseController
  def exist
    if User.find_by(email: params[:email])
      render json: { success: true }, status: 200
    else
      render json: { errors: false }, status: 404
    end
  end
end
