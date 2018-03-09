class AddVariantFilesToVariants < ActiveRecord::Migration
  def change
    add_column :variants, :variant_files, :jsonb, null: false, default: '[]'
    #add_index  :variants, :variant_files, using: :gin
  end
end
