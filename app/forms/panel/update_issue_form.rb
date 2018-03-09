class Panel::UpdateIssueForm
  include ActiveModel::Model

  attr_accessor(
      :volume_id, :pages, :pdf_pages_not_save, :url, :description, :publication_date,
      :title, :cover_image, :magazine_id
  )

  validates :title, :cover_image, :publication_date, presence: true
  validates :publication_date, date: true

  def initialize(issue_attrs, form_attributes = {})
    super issue_attrs.merge(form_attributes)
  end

  def attributes
    {
      title: title,
      volume_id: volume_id,
      pages: pages,
      url: url,
      description: description,
      publication_date: get_publication_date,
    }
  end

  def get_publication_date
    Date.parse(publication_date).beginning_of_day
  end

  def cover_image_attributes
    if cover_image.is_a?(Hash)
      cover_image
    elsif cover_image.is_a?(IssueCoverImage)
      cover_image&.attributes
    else
       {}
    end
  end
end
