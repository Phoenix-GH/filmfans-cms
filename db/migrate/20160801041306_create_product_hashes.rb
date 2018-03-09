class CreateProductHashes < ActiveRecord::Migration
  def change
    create_table :product_hashes, id: false do |t|
      t.primary_key :product_id
      t.string :product_hash, index: true
    end

    add_foreign_key :product_hashes, :products, on_delete: :cascade

    execute <<-SQL
      INSERT INTO product_hashes (product_id, product_hash)
      SELECT id, product_hash from products;
    SQL

  end
end
