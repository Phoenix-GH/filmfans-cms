class UpdateCategoryName < ActiveRecord::Migration
  def change
    execute <<-SQL
      UPDATE categories set name = 'Lingerie', display_name = 'Woman > Lingerie' where id in (87, 161);
      UPDATE categories set name = 'Sneakers', display_name = 'Man > Shoes > Sneakers' where id = 118;
      UPDATE categories set name = 'Sneakers', display_name = 'Woman > Shoes > Sneakers' where id = 140;
      UPDATE categories set name = 'Dress Shirts', display_name = 'Man > Shirts > Dress Shirts' where id = 91;
      UPDATE categories set name = 'Dress Shirts', display_name = 'Man > Shirts > Dress Shirts' where id = 91;

      UPDATE categories set name = 'Earrings', display_name = 'Woman > Earrings' where id in (78, 149);
    SQL
  end
end
