class AddManualAddedProductVendor < ActiveRecord::Migration
  def change
    execute <<-SQL
      INSERT INTO stores (id, name, created_at, updated_at)
      values (10000, 'Manually added products', now(), now())
    SQL
  end
end
