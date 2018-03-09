module Showtimes
  extend ActiveSupport::Concern

  module ClassMethods
    def showtimes_connection
      @conn ||= Faraday.new(:url => 'https://api.internationalshowtimes.com') do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter
        faraday.headers['Authorization'] = 'Token token=DgEw3jjxAc1G5Jcn1Dv735jZ8H2DBzNa'
      end
    end

    def showtimes_genres
      respond = showtimes_connection.get '/v4/genres', { :lang => 'en'}
      raise "Errors receive data from internationalshowtimes.com" if respond.status != 200
      ActiveSupport::JSON.decode(respond.body)
    end

    def showtimes_movies
      respond = showtimes_connection.get '/v4/movies', { :lang => 'en'}
      raise "Errors receive data from internationalshowtimes.com" if respond.status != 200
      ActiveSupport::JSON.decode(respond.body)
    end

    def showtimes_movie id
      respond = showtimes_connection.get "/v4/movies/#{id}", { :lang => 'en'}
      raise "Errors receive data from internationalshowtimes.com" if respond.status != 200
      ActiveSupport::JSON.decode(respond.body)
    end
  end
end
