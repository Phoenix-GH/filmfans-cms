class AddSpecificationToMediaContent < ActiveRecord::Migration
  def change
    add_column :media_contents, :specification, :text
  end
end
