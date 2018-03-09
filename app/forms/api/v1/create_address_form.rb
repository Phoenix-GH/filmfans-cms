class Api::V1::CreateAddressForm
  include ActiveModel::Model

  attr_accessor(
    :label, :city, :street, :zip_code, :country, :primary
  )

  validates :city, :street, :zip_code, :country, :primary, presence: true

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
