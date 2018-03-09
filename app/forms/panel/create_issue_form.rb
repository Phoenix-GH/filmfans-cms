class Panel::CreateIssueForm
  include ActiveModel::Model


  attr_accessor(
    :volume_id, :pages ,:url, :description, :publication_date,
    :title, :cover_image, :magazine_id
  )

  validates :title, :publication_date, presence: true
  validates :publication_date, date: true

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
    cover_image || {}
  end
end


