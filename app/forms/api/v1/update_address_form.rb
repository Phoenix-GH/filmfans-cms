class Api::V1::UpdateAddressForm
  include ActiveModel::Model

  attr_accessor(
    :label, :city, :street, :zip_code, :country, :primary
  )

  def initialize(address_attrs, form_attributes = {})
    super address_attrs.merge(form_attributes)
  end

  validates :city, :street, :zip_code, :country, :primary, presence: true, allow_blank: false

  def address_attributes
    {
      label: label,
      city: city,
      street: street,
      zip_code: zip_code,
      country: country,
      primary: primary_flag
    }
  end

  private
  def primary_flag
    primary.to_i == 1 ? true : false
  end
end
