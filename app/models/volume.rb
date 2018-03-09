class Volume < ActiveRecord::Base
  belongs_to :magazine
  has_many :issues, -> { order('publication_date desc') }, dependent: :destroy
end
