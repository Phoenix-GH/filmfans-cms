class AddSearchedPhrasesCounterDefault < ActiveRecord::Migration
  def change
    change_column_default :searched_phrases, :counter, 0
  end
end
