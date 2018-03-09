class AddDescriptionToVariant < ActiveRecord::Migration
  def change
    add_column :variants, :description, :string
  end
end
