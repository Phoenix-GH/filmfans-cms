require 'optparse'
require 'csv'

namespace :import do
  desc 'import movies from api.internationalshowtimes.com (gruvi.tv)'
  task :import_movies_gruvi => :environment  do
    Movie.load_movies
  end
end


