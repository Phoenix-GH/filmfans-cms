class Genre < ActiveRecord::Base
  include Showtimes

  def self.load_genres
    showtimes_genres['genres'].each do |g|
      next if  g['name'].nil?
      genre =  Genre.where('lower(name) = ?', g['name'].downcase).first
      if genre.nil?
        genre = Genre.create!({:name =>  g['name'], :showtime_id => g['id']})
      end
    end
  end

  def as_json(options={})
    { :name => self.name, :id => self.id }
  end

  def self.active
    where('name IS NOT NULL').order(:name)
  end
end
