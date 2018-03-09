class Movie < ActiveRecord::Base
  include Showtimes

  has_many :movie_containers, through: :linked_movies
  has_many :linked_movies, dependent: :destroy

  #belongs_to :admin
  #has_one :cover_image, class_name:  'EventCoverImage', dependent: :destroy
  #has_one :background_image, class_name:  'EventBackgroundImage', dependent: :destroy
  #ccepts_nested_attributes_for :cover_image
  #accepts_nested_attributes_for :background_image

  has_many :movie_products, dependent: :destroy
  has_many :products, -> { order('position asc') }, through: :movie_products


  has_and_belongs_to_many :genres
  has_and_belongs_to_many :actors

  serialize :poster_image
  serialize :scene_images
  serialize :trailers
  serialize :age_limits
  serialize :keywords

  def cover_image_url
    self.poster_image_thumbnail
  end

  def name
    self.title
  end

  def self.load_movies
    showtimes_movies['movies'].each do |m|
      puts "Try to add movies with 'howtime_id' = #{m['id']}"
      movie = Movie.find_by_showtime_id(m['id'])
      if movie.nil?
        movie = Movie.create!({ :showtime_id => m['id'], :title => m['title'], :poster_image_thumbnail => m['poster_image_thumbnail']})
      end

      movie_details = showtimes_movie(movie.showtime_id)
      return if movie_details.nil?
      movie_details = movie_details['movie']

      movie.slug =  movie_details['slug']
      movie.original_title =  movie_details['original_title']
      movie.synopsist =  movie_details['synopsist']
      movie.runtime =  movie_details['runtime']
      movie.poster_image_thumbnail =  movie_details['poster_image_thumbnail']

      unless  movie_details['ratings'].nil?
        movie.ratings_imdb_value =  movie_details['ratings']['imdb']['value'] unless movie_details['ratings']['imdb'].nil?
        movie.ratings_imdb_vote_count =  movie_details['ratings']['imdb']['vote_count'] unless movie_details['ratings']['imdb'].nil?

        movie.ratings_tmdb_value =  movie_details['ratings']['tmdb']['value'] unless movie_details['ratings']['tmdb'].nil?
        movie.ratings_tmdb_vote_count =  movie_details['ratings']['tmdb']['vote_count'] unless movie_details['ratings']['tmdb'].nil?
      end

      movie.imdb_id =  movie_details['imdb_id']
      movie.tmdb_id =  movie_details['tmdb_id']
      movie.rentrak_film_id =  movie_details['rentrak_film_id']

      movie.age_limits =  movie_details['age_limits']
      movie.release_dates =  movie_details['release_dates']

      movie.website =  movie_details['website']
      movie.keywords =  movie_details['keywords']
      movie.poster_images =  movie_details['poster_image']
      movie.scene_images =  movie_details['scene_images']
      movie.trailers =  movie_details['trailers']

      movie_details['genres'].each do |g|
        genre = Genre.find_by_showtime_id(g['id'])
        if genre.nil?
          genre = Genre.create!({:showtime_id => g['id'], :name => g['name']})
        end
        movie.genres <<  genre unless movie.genres.exists?(genre)
      end unless movie_details['genres'].nil?

      movie_details['cast'].each do |g|
        actor = Actor.find_by_showtime_id(g['id'])
        if actor.nil?
          actor = Actor.create!({:showtime_id => g['id'], :name => g['name'], :character => g['character'], :job => 'actor'})
        end
        movie.actors << actor unless movie.actors.exists?(actor)
      end unless movie_details['cast'].nil?

      movie_details['crew'].each do |g|
        actor = Actor.find_by_showtime_id(g['id'])
        if actor.nil?
          actor = Actor.create!({:showtime_id => g['id'], :name => g['name'],  :job => g['job']})
        end
        movie.actors << actor unless movie.actors.exists?(actor)
      end unless movie_details['crew'].nil?

      movie.save!
    end
  end

end
