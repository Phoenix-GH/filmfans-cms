class CreateExtVisionSuggestion < ActiveRecord::Migration
  def change
    create_table :ext_vision_suggestions, {:id => false} do |t|
      t.integer :product_id
      t.jsonb :keywords, null: true, default: '{}'
      t.string :image_url
      t.string :type
    end
    execute "ALTER TABLE ext_vision_suggestions ADD PRIMARY KEY (product_id);"
  end
end
