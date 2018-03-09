class UpdateDatabaseSchemaOnNewImport < ActiveRecord::Migration
  def change
    # Change on table products
    remove_column :products, :product_hash
    remove_index :products, :tsv
    remove_column :products, :tsv
    add_column :products, :vendor_product_image_url, :text
    add_column :products, :product_group, :string
    add_index :products, :product_group

    # Drop table product_hash
    drop_table :product_hashes

    # Create :affiliates table
    create_table :affiliates do |t|
      t.string  :name , null: false, default: ''
    end

    # Add foreign key for store and affiliates
    add_column :stores, :affiliate_id, :integer
    add_foreign_key :stores, :affiliates
    add_index :stores, :affiliate_id


  end
end