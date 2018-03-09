class AddVideoToManualPosts < ActiveRecord::Migration
  def change
    add_column :manual_posts, :video, :string
  end

end
