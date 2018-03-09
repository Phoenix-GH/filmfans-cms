class ModifyPrimaryKeyExtVisionSuggestion < ActiveRecord::Migration
  def change
    execute "ALTER TABLE ext_vision_suggestions DROP CONSTRAINT ext_vision_suggestions_pkey;"
    execute "ALTER TABLE ext_vision_suggestions ADD PRIMARY KEY (product_id,type);"
  end
end
