class Panel::SaveIssueUploadedPdfForm
  include ActiveModel::Model

  attr_accessor(
      :pdf_user_file_name, :pdf_file_name, :pdf_url, :image_url_prefix, :total_pages
  )

  validates :pdf_user_file_name, :pdf_file_name, :pdf_url, :image_url_prefix, presence: true
  validates :total_pages, :presence => true, :numericality => {:greater_than => 0}

  def attributes
    {
        pdf_user_file_name: pdf_user_file_name,
        pdf_file_name: pdf_file_name,
        pdf_url: pdf_url,
        image_url_prefix: image_url_prefix,
        total_pages: total_pages
    }
  end
end