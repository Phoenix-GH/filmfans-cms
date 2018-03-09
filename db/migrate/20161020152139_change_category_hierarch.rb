class ChangeCategoryHierarch < ActiveRecord::Migration
  def change
    execute <<-SQL
      -- Woman
      -- Jeans should go into Pants
      update categories set parent_id = 221 where id = 134;
      delete from categories where id = 69;

      -- Suits should go into Suits, Coats & Sweaters
      update categories set parent_id = 220 where id = 162;
      delete from categories where id = 88;

      update categories set name = 'Tops & Tees' where id = 219;
    SQL
  end
end
