class AddPositionToTvShows < ActiveRecord::Migration
  def change
    add_column :tv_shows, :position, :integer
    add_index :tv_shows, [:position, :id]
  end
end
