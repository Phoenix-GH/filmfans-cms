class CreateManualPosts < ActiveRecord::Migration
  def change
    create_table :manual_posts do |t|
      t.string :name, null: false
      t.string :image
      t.boolean :visible, null: false, default: true
      t.text :specification, null: false, default: '{}'
      t.references :media_owner, index: true, foreign_key: true, null: true
      t.references :channel, index: true, foreign_key: true, null: true

      t.timestamps
    end

    create_table :manual_post_products do |t|
      t.references :manual_post, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end

    create_table :manual_post_containers do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :linked_manual_posts do |t|
      t.references :manual_post, foreign_key: true
      t.references :manual_post_container, foreign_key: true
      t.integer :position
      t.timestamps
    end

    add_index :linked_manual_posts, :manual_post_id,
              name: 'index_lnk_mposts_on_mpost_id'
    add_index :linked_manual_posts, :manual_post_container_id,
              name: 'index_lnk_mpost_on_container_id'
    add_index :linked_manual_posts, [:manual_post_id, :manual_post_container_id],
              name: 'index_lnk_mpost_on_mpost_container'

  end

  def down
    drop_table :manual_post_products
    drop_table :manual_posts
    drop_table :linked_manual_posts
    drop_table :manual_post_containers
  end

end
