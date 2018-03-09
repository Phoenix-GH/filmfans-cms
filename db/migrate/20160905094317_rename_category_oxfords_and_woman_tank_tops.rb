class RenameCategoryOxfordsAndWomanTankTops < ActiveRecord::Migration
  def change
    execute <<-SQL
      UPDATE categories set name = 'Tops', display_name = 'Woman > Tops' where id in (75, 144);
      UPDATE categories set name = 'Dress shoes', display_name = 'Man > Shoes > Dress shoes' where id = 94;
    SQL
  end
end
