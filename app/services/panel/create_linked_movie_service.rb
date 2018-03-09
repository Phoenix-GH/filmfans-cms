class Panel::CreateLinkedMovieService
  def initialize(container, linked_movies = [])
    @container = container
    @linked_movies = linked_movies
  end

  def call
    ActiveRecord::Base.transaction do
      remove_old_linked_movies
      create_new_linked_movies
    end
  end

  private
  def remove_old_linked_movies
    @container.linked_movies.delete_all
  end

  def create_new_linked_movies
    @linked_movies.each do |linked_movie|
      position = linked_movie[:position]
      movie = Movie.find_by(id: linked_movie[:movie_id])
      if movie
        @container.linked_movies.create(movie: movie, position: position)
      end
    end
  end
end
