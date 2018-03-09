class RenameCasualDresses < ActiveRecord::Migration
  def change
    execute <<-SQL
      UPDATE categories set name = 'Dresses' where id = 146;
    SQL
  end
end
