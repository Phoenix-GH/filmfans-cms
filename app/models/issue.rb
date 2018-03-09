class Issue < ActiveRecord::Base
  belongs_to :volume

  has_many :issue_pages, -> { order('page_number asc') }, dependent: :destroy
  has_one :cover_image, class_name: 'IssueCoverImage', dependent: :destroy
  accepts_nested_attributes_for :cover_image

  def missing_page_images
    return [] unless !self.pdf_pages.nil? && self.pdf_pages > 0

    pages = Array(1..self.pdf_pages)

    self.issue_pages.each do |page|
      pages.delete(page.page_number) if page.image&.file&.exists?
    end

    pages
  end

  def number_of_pages
    return pdf_pages if pdf_pages
    pages
  end
end
