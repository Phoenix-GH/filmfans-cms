class Panel::BaseSocialCategoryForm
  include ActiveModel::Model

  attr_accessor(
      :name, :image
  )

  validates :name, presence: true

  def attributes
    {
        name: name,
        image: image
    }
  end
end
