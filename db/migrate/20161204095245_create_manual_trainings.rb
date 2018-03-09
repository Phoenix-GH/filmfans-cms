class CreateManualTrainings < ActiveRecord::Migration
  def change
    create_table :manual_trainings do |t|
      t.references :product, index: true, foreign_key: true
      t.string :category
      t.timestamps null: false
    end

    create_table :manual_training_user_images do |t|
      t.references :manual_training, index: true, foreign_key: true
      t.text :image_url, null: true
      t.text :image, null: true
      t.string :uuid, null: false
      t.timestamps null: false
    end

    create_table :manual_training_products do |t|
      t.references :manual_training, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
