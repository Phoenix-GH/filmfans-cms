class AssignImagingFolderToToteBag < ActiveRecord::Migration
  def change
    execute <<-SQL
      UPDATE categories set imaging_category = 'woman_shoulder_bag' where id = 176;
    SQL
  end
end
