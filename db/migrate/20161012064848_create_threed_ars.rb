class CreateThreedArs < ActiveRecord::Migration
  def change
    create_table :threed_ars do |t|
      t.text :name, null: false
      t.text :message, null: true
      t.string :image
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.string :ar_collection_id

      t.timestamps
    end

    create_table :threed_models do |t|
      t.string :description
      t.string :file
      t.string :image
      t.references :threed_ar, index: true, foreign_key: true, null: false
      t.integer :position

      t.timestamps
    end

    create_table :threed_model_products do |t|
      t.references :threed_model, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end

  end

  def down
    drop_table :threed_model_products
    drop_table :threed_models
    drop_table :threed_ars
  end
end
