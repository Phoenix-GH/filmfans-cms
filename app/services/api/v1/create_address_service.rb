class Api::V1::CreateAddressService
  attr_reader :address

  def initialize(form, user)
    @form = form
    @user = user
  end

  def call
    return false unless @form.valid?

    ActiveRecord::Base.transaction do
      create_primary_flags
      create_address
    end
  end

  private
  def create_primary_flags
    if @form.address_attributes[:primary]
      @user.addresses.update_all(primary: false)
    elsif @user.addresses.primary.count.zero?
      @form.address_attributes[:primary] = true
    end
  end

  def create_address
    @address = @user.addresses.create(@form.address_attributes)
  end
end
