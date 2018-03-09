class AddInstagramStatusToMovieCelebrities < ActiveRecord::Migration
  def change
    add_column :movie_celebrity_mappings, :instagram_status, :string, null: true, index: true

  end
end
