class AddIndexesToNewTables < ActiveRecord::Migration
  def change
    add_index :campain_contents, :campain_id
    add_index :campain_contents, [:content_id, :content_type]

    add_index :linked_products, :products_container_id
    add_index :linked_products, :product_id

    add_index :media_containers, :media_owner_id
  end
end
