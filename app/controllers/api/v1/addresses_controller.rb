class Api::V1::AddressesController < Api::V1::BaseController
  before_action :authenticate_api_v1_user!, only: [:create, :index, :update, :destroy]
  before_action :set_address, only: [:update, :destroy]

  def index
    addresses = current_api_v1_user.addresses

    render json: addresses.map { |res| AddressSerializer.new(res).results }
  end

  def create
    form =  Api::V1::CreateAddressForm.new(address_form_params)
    service = Api::V1::CreateAddressService.new(form, current_api_v1_user)

    if service.call
      render json: AddressSerializer.new(service.address).results
    else
      render json: form.errors.full_messages, status: 400
    end
  end

  def update
    form = Api::V1::UpdateAddressForm.new(address_attributes, address_form_params)
    service = Api::V1::UpdateAddressService.new(@address, form)

    if service.call
      render json: AddressSerializer.new(service.address).results
    else
      render json: form.errors.full_messages, status: 400
    end
  end

  def destroy
    Api::V1::DestroyAddressService.new(@address).call
    render nothing: true, status: 200
  end

  private
  def address_form_params
    params.permit(:label, :city, :street, :zip_code, :country, :primary)
  end

  def set_address
    @address = current_api_v1_user.addresses.find(params[:id])
  end

  def address_attributes
    @address.slice('label', 'city', 'street', 'zip_code', 'country', 'primary')
  end
end
