class CreateProductKeywords < ActiveRecord::Migration
  def change
    create_table :product_keywords, id: false do |t|
      t.primary_key :product_id
      t.jsonb :ibm_keywords, null: true, default: '{}'
      t.jsonb :ulab_keywords, null: true, default: '{}'
      t.jsonb :google_keywords, null: true, default: '{}'
      t.jsonb :clarifai_keywords, null: true, default: '{}'
      t.jsonb :microsoft_keywords, null: true, default: '{}'
      t.string :image_url
      t.boolean :indexed, null: false, default: false
    end

    add_foreign_key :product_keywords, :products, on_delete: :cascade

    execute <<-SQL
      ALTER TABLE product_keywords ALTER COLUMN product_id DROP DEFAULT;
      DROP SEQUENCE product_keywords_product_id_seq;
    SQL

    execute <<-SQL
      INSERT INTO product_keywords (product_id, ibm_keywords, image_url)
      SELECT product_id, keywords, image_url from ext_vision_suggestions;
    SQL
  end
end
