class RestructureWomanBags < ActiveRecord::Migration
  def change
    execute <<-SQL
      UPDATE categories set name = 'Bags', display_name = 'Woman > Bags' where id = 82;
      UPDATE categories set parent_id = 82 where id = 176;
      DELETE from categories where id = 175;
    SQL
  end
end
