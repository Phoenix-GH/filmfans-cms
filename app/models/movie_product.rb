class MovieProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :movie
end