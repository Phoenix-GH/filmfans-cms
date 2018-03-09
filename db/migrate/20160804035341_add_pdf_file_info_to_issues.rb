class AddPdfFileInfoToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :pdf_file_name, :string
    add_column :issues, :pdf_url, :string
    add_column :issues, :pdf_image_base_url, :string
    add_column :issues, :pdf_pages, :integer
  end
end
