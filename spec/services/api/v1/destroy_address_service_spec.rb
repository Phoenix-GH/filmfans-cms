describe Api::V1::DestroyAddressService do
  it 'destroy address' do
    address = create(:address)
    service = Api::V1::DestroyAddressService.new(address)
    expect{ service.call }.to change(Address, :count).by(-1)
  end

  it 'set other primary address' do
    user = create(:user)
    primary_address = create(:address, user: user, primary: true)
    address = create(:address, user: user, primary: false)

    Api::V1::DestroyAddressService.new(primary_address).call
    expect( address.reload.primary ).to eq(true)
  end
end
