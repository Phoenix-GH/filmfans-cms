class RenameRelatedProductToProductSimilarity < ActiveRecord::Migration
  def change
    rename_table :related_products, :product_similarity
    rename_column :product_similarity, :related_from_id, :product_from_id
    rename_column :product_similarity, :related_to_id, :product_to_id
  end
end
