class TvShowSeason < ActiveRecord::Base
  belongs_to :tv_show
  has_many :episodes, dependent: :destroy

  validates :number, uniqueness: { scope: :tv_show_id }
end
