class Panel::SupportEnquiryForm
  include ActiveModel::Model

  attr_accessor(:subject, :content)

  validates :subject, :content, presence: true

  def initialize(form_attributes = {})
    super form_attributes
  end
end
