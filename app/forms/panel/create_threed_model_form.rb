class Panel::CreateThreedModelForm < Panel::BaseThreedModelForm
  validates :file, presence: true

end