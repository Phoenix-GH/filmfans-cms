class RenameOptionValueVariantFilesToVariantFile < ActiveRecord::Migration
  def change
    rename_table :option_value_variant_files, :variant_files
    rename_column :variant_files, :option_value_variant_id, :variant_id
  end
end
