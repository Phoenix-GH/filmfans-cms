class Api::V1::HomesController < Api::V1::BaseController
  before_filter :set_default_params

  def current
    homes = HomeQuery.new(homes_params.merge(published: true)).results
    home_json = HomeSerializer.new(home: homes.first,
                                   current_country: homes_params[:current_country],
                                   language: homes_params[:language]).results
    gracenote_service = Movie::GracenoteMovieService.new(request.remote_ip)

    unless homes.blank?
      if homes_params[:home_type] == 'trending'
        trending_movies = gracenote_service.home_trending_movies(zipcode: homes_params[:zipcode],
                                                                 latitude: homes_params[:latitude],
                                                                 longitude: homes_params[:longitude])
        home_json[:movies_containers].each do |c|
          if c[:name].downcase == 'now showing'
            c[:movies] = trending_movies[:now_showing]
          elsif c[:name].downcase == 'up coming'
            c[:movies] = trending_movies[:up_coming]
          end
        end
        home_json[:single_movie_containers] = trending_movies[:single_movie_containers].map { |mv|
          mv.merge({
                       position: -1, # always on top
                       width: 'full'
                   })
        }

      elsif homes_params[:home_type] == 'now_showing'
        home_json[:single_movie_containers] = gracenote_service.home_now_showing_movies(zipcode: homes_params[:zipcode],
                                                                                        latitude: homes_params[:latitude],
                                                                                        longitude: homes_params[:longitude])
      elsif homes_params[:home_type] == 'up_coming'
        home_json[:movies_containers] = gracenote_service.home_up_coming_movies(zipcode: homes_params[:zipcode],
                                                                                latitude: homes_params[:latitude],
                                                                                longitude: homes_params[:longitude])
      end
    end

    render json: home_json
  end

  private

  def homes_params
    params.permit(:home_type, :current_country, :language, :zipcode, :latitude, :longitude)
  end

  def set_default_params
    params[:home_type] ||= 'trending'
    params[:zipcode] ||= ENV['MOVIE_FALLBACK_ZIPCODE']
  end
end
