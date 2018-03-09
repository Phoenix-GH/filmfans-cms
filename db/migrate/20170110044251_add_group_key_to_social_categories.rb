class AddGroupKeyToSocialCategories < ActiveRecord::Migration
  def change
    add_column :social_categories, :group_key, :string

    execute <<-SQL
      UPDATE social_categories SET group_key = 'recommendations' where id = 1;
      UPDATE social_categories SET group_key = 'trending' where id = 2;
      UPDATE social_categories SET group_key = 'sponsored' where name = 'Sponsored';
    SQL
  end

end
