class Panel::UpdateAccountForm
  include ActiveModel::Model

  attr_accessor(:id, :full_name, :email)

  validates :email, presence: true

  def initialize(account_attributes, form_attributes = {})
    super account_attributes.merge(form_attributes)
  end

  def account_attributes
    {
      full_name: full_name,
      email: email
    }
  end
end
