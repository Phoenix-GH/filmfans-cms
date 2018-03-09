class AddressSerializer
  def initialize(address)
    @address = address
  end

  def results
    return {} unless @address
    generate_address_json
  end

  private
  def generate_address_json
    {
      id: @address.id,
      user_id: @address.user_id,
      label: @address.label.to_s,
      city: @address.city.to_s,
      street: @address.street.to_s,
      zip_code: @address.zip_code.to_s,
      country: @address.country.to_s,
      primary: @address.primary.to_s
    }
  end
end
