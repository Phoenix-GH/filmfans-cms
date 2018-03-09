class Panel::Wizards::UpdateSizeForm
  include ActiveModel::Model

  attr_accessor(
      :size, :price, :currency, :_destroy
  )

  validates_presence_of :price # :size,

  def initialize(size_attributes={}, form_attributes = {})
    super defaults.merge(size_attributes).merge(form_attributes)
  end

  private
  def defaults
    { currency: 'USD' }
  end
end
