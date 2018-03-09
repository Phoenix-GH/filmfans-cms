class ModifyCategoryStructure < ActiveRecord::Migration
  def change
    add_column :categories, :imaging_category, :string
    add_column :categories, :level, :integer
    add_column :categories, :unisex, :boolean, default: false
  end
end
