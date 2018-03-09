class UpdateImagingCategory < ActiveRecord::Migration
  def change
    execute <<-SQL
      update categories set imaging_category = 'woman_underwear' where imaging_category = 'woman_underwaer';
    SQL
  end
end
