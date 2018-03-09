class AddDefaultValueForSpecification < ActiveRecord::Migration
  def up
    change_column :media_owner_pictures, :specification, :text, default: {}.to_json
    change_column :media_owner_background_images, :specification, :text, default: {}.to_json
  end

  def down
  end
end
