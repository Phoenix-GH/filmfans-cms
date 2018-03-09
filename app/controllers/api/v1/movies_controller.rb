class Api::V1::MoviesController < Api::V1::BaseController
  before_action :authenticate_if_token
  before_filter :set_default_params, except: [:validate_zipcode, :validate_geolocation]

  # only search movies
  def index
    render json: gracenote_service.search_movies(movies_params[:search],
                                                 movies_params[:page],
                                                 movies_params[:per])[:movies]
  end

  # search movies, products
  def universal_search
    render json: Movie::UniversalSearchService.new(request.remote_ip).search(
        search: universal_search_params[:search],
        page: universal_search_params[:page])
  end

  def show
    movie = gracenote_service.get_movie_detail(composite_id: movie_detail_params[:id])

    if movie.blank?
      render json: {}
    else
      render json: GracenoteMoveDetailSerializer.new(movie, request.remote_ip).results
    end
  end

  def trailer
    render json: {
        movie_id: trailer_params[:id],
        url: gracenote_service.get_trailer(trailer_params[:id])
    }
  end

  def ticket
    render json: gracenote_service.get_showtimes(composite_id: ticket_params[:id],
                                                 zipcode: ticket_params[:zipcode],
                                                 latitude: ticket_params[:latitude],
                                                 longitude: ticket_params[:longitude])
  end

  def celebrity
    # require personId
    celebrity = gracenote_service.celebrity_detail(celebrity_detail_params[:id])
    render json: GracenoteCelebrityDetailSerializer.new(celebrity, request.remote_ip).results
  end

  def theatre
    render json: gracenote_service.get_theatre_detail(theatre_params[:id])
  end

  def validate_zipcode
    zipcode = params[:zipcode]

    if zipcode.blank?
      render json: {
          code: 'FAILED',
          msg: 'zipcode is required'
      }
    end

    geo = GeoHelper.geocode(zipcode: zipcode, latitude: nil, longitude: nil)

    render json: validate_geo(geo)
  end

  def validate_geolocation
    latitude = geo_params[:latitude]
    longitude = geo_params[:longitude]

    if latitude.blank? || longitude.blank?
      render json: {
          code: 'FAILED',
          msg: 'latitude and longitude are required'
      }
    else
      geo = GeoHelper.geocode(zipcode: nil, latitude: latitude, longitude: longitude)

      render json: validate_geo(geo)
    end
  end

  def popular
    container = MoviesContainer.where('lower(name) = ?', 'popular').first

    results = []
    unless container.blank?
      results = container.movies
                    .select { |m| !m.gracenote_id.blank? }
                    .map { |m| gracenote_service.get_movie_detail(composite_id: m.gracenote_id) }
                    .select { |m| !m.blank? }
                    .map { |m| GracenoteMovieBriefSerializer.new(m).results }
    end
    render json: results
  end

  private

  def validate_geo(geo)
    if geo.blank?
      return {
          code: 'FAILED',
          msg: 'Cannot determine the geolocation'
      }
    end

    if geo.country_code == 'US'
      {
          code: 'OK',
          msg: 'Valid geolocation',
          latitude: geo.lat,
          longitude: geo.lng,
          zipcode: geo.zip,
          country: geo.country_code,
          city: geo.city
      }
    else
      {
          code: 'FAILED',
          msg: 'FilmFans only supports US',
          country: geo.country_code
      }
    end
  end

  def gracenote_service
    @gracenote_service ||= Movie::GracenoteMovieService.new(request.remote_ip)
  end

  def geo_params
    params.permit(:latitude, :longitude)
  end

  def movies_params
    params.permit(:search, :page, :per)
  end

  def universal_search_params
    params.permit(:search, :page)
  end

  def movie_detail_params
    params.permit(:id)
  end

  def celebrity_detail_params
    params.permit(:id)
  end

  def ticket_params
    params.permit(:id, :zipcode, :latitude, :longitude)
  end

  def trailer_params
    params.permit(:id)
  end

  def set_default_params
    params[:zipcode] ||= ENV['MOVIE_FALLBACK_ZIPCODE']
  end

  def theatre_params
    params.permit(:id)
  end

end
