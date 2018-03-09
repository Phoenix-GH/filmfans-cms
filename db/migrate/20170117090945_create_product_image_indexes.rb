class CreateProductImageIndexes < ActiveRecord::Migration
  def change
    create_table :product_image_index_adds do |t|
      t.integer :variant_id, null: true
      t.integer :category_id, null: false
      t.integer :product_id, null: false
      t.boolean :in_house, default: false
      t.boolean :bb_viz, default: false
      t.boolean :ulab_viz, default: false
    end

    create_table :product_image_index_removes do |t|
      t.integer :variant_id, null: true
      t.integer :category_id, null: false
      t.integer :product_id, null: false
      t.boolean :in_house, default: false
      t.boolean :bb_viz, default: false
      t.boolean :ulab_viz, default: false
    end

    # add foreign keys
    add_foreign_key :product_image_index_adds, :variants
    add_foreign_key :product_image_index_adds, :products
    add_foreign_key :product_image_index_adds, :categories

    add_foreign_key :product_image_index_removes, :variants
    add_foreign_key :product_image_index_removes, :products
    add_foreign_key :product_image_index_removes, :categories

    # add unique index 3 IDs
    add_index :product_image_index_adds, [:product_id, :category_id, :variant_id], name: 'insert_pcv_index', unique: true
    add_index :product_image_index_removes, [:product_id, :category_id, :variant_id], name: 'remove_pcv_index', unique: true

    # add index cho category_id, product_id
    add_index :product_image_index_adds, [:product_id, :category_id], name: 'insert_pc_index'
    add_index :product_image_index_removes, [:product_id, :category_id], name: 'remove_pc_index'
  end
end
