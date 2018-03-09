class Api::V1::ThreedArsController < Api::V1::BaseController
  before_action :authenticate_if_token

  def show
    return '' if search_params[:id].blank?

    @results = ThreedAr.find(search_params[:id])

    render json: ThreedArSerializer.new(@results).results
  end

  def search_params
    params.permit(:id)
  end
end
