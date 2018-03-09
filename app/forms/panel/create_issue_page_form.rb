class Panel::CreateIssuePageForm
  include ActiveModel::Model

  attr_accessor(
      :issue_id, :image, :description
  )

  validates :image, :description, presence: true
  validates :image, image_format: true

  def attributes
    {
        description: description,
        issue_id: issue_id
    }
  end

  def image_attributes
    image || {}
  end
end
