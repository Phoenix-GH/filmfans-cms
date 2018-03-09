class Api::V1::DestroyAddressService
  attr_reader :address

  def initialize(address)
    @address = address
  end

  def call
    destroy_address
    set_primary
  end

  private
  def destroy_address
    @address.destroy
  end

  def set_primary
    if @address.primary
      @address.user.addresses.first&.update(primary: true)
    end
  end
end
