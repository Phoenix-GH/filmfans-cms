class Api::V1::CarouselsController < Api::V1::BaseController
  before_filter :set_default_params

  def home
    render json: CarouselSerializer.new(client_ip: request.remote_ip,
                                        zipcode: home_params[:zipcode],
                                        latitude: home_params[:latitude],
                                        longitude: home_params[:longitude]).results
  end

  private

  def home_params
    params.permit(:home_type, :current_country, :language, :zipcode, :latitude, :longitude)
  end

  def set_default_params
    params[:zipcode] ||= ENV['MOVIE_FALLBACK_ZIPCODE']
  end
end
