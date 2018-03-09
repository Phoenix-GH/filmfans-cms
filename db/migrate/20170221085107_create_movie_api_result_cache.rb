class CreateMovieApiResultCache < ActiveRecord::Migration
  def change
    create_table :movie_api_result_caches do |t|
      t.string :endpoint, unique: true
      t.string :client_ip

      t.json :content

      t.timestamps null: false
    end

    add_index :movie_api_result_caches, [:endpoint, :created_at]
  end
end
