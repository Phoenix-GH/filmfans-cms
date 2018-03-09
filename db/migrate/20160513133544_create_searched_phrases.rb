class CreateSearchedPhrases < ActiveRecord::Migration
  def change
    create_table :searched_phrases do |t|
      t.string :phrase
      t.integer :counter

      t.timestamps null: false
    end
  end
end
