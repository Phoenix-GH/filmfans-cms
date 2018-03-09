class Panel::CreateSocialCategoryForm < Panel::BaseSocialCategoryForm
  validates :image, presence: true, image_format: true
end
