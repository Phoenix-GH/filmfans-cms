class Api::V1::UpdateAddressService
  attr_reader :address

  def initialize(address, form)
    @address = address
    @form = form
  end

  def call
    return false unless @form.valid?

    ActiveRecord::Base.transaction do
      update_primary_flags
      update_address
    end
  end

  private
  def update_primary_flags
    if @form.address_attributes[:primary]
      @address.user.addresses.where.not(id: @address.id).update_all(primary: false)
    elsif (other_addresses = @address.user.addresses.where.not(id: @address.id)).any?
      return if other_addresses.primary.any?
      other_addresses.first&.update(primary: true)
    else
      @form.address_attributes[:primary] = true
    end
  end

  def update_address
    @address.update_attributes(@form.address_attributes)
  end
end
