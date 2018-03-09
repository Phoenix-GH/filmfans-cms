class AddDefaultCategory < ActiveRecord::Migration
  def change
    add_column :social_categories, :is_top, :boolean, null: false, default: false, index: true

    reversible do |dir|
      dir.up do
        ["Recommendations", "Trending"].each do |cat_name|
          SocialCategory.create!({name: cat_name, is_top: true})
        end
      end
    end

  end
end
