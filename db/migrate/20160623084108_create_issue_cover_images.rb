class CreateIssueCoverImages < ActiveRecord::Migration
  def change
    create_table :issue_cover_images do |t|
      t.string :file
      t.text :specification, default: {}.to_json
      t.references :issue, index: true, foreign_key: true

      t.timestamps
    end
  end
end
