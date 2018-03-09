class AddDisplayOptionToManualPost < ActiveRecord::Migration
  def change
    add_column :manual_posts, :display_option, :integer, null: false, :default => 2
    add_index :manual_posts, :display_option
  end
end
