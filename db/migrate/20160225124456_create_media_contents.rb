class CreateMediaContents < ActiveRecord::Migration
  def change
    create_table :media_contents do |t|
      t.string :type
      t.string :file
      t.references :membership, polymorphic: true

      t.timestamps null: false
    end
  end
end
