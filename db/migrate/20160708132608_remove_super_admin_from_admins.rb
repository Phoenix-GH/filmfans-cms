class RemoveSuperAdminFromAdmins < ActiveRecord::Migration
  def up
    migrate_superadmins
    remove_column :admins, :superadmin
  end

  def down
    add_column :admins, :superadmin, :boolean, default: false
  end

  private
  def migrate_superadmins
    Admin.where(superadmin: true).each do |admin|
      admin.role = 'super_admin'
      admin.save
    end
  end
end
