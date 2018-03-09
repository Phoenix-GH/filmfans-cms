class CreateProductFiles < ActiveRecord::Migration
  def change
    create_table :product_files do |t|
      t.references :product, index: true
      t.string   :file_type
      t.string   :file
      t.string   :cover_image
      t.text     :specification
      t.string   :small_version_url
      t.string   :normal_version_url
      t.string   :large_version_url

      t.timestamps null: false
    end
  end
end
