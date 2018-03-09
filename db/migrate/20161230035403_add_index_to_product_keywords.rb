class AddIndexToProductKeywords < ActiveRecord::Migration
  def change
    add_index :product_keywords, [:indexed]
  end
end
