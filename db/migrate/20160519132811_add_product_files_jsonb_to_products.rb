class AddProductFilesJsonbToProducts < ActiveRecord::Migration
  def change
    add_column :products, :product_files, :jsonb, null: false, default: '[]'
    #add_index  :products, :product_files, using: :gin
  end
end
