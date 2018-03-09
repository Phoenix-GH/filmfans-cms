describe Api::V1::CreateAddressService do
  it 'call' do
    user = create(:user)
    address_attributes = {
      label: 'label',
      city: 'Name',
      street: 'Street 12',
      zip_code: '01-222',
      country: 'Poland'
    }
    form = double(
      valid?: true,
      address_attributes: address_attributes
    )

    service = Api::V1::CreateAddressService.new(form, user)
    expect { service.call }.to change { Address.count }.by(1)
    expect { service.call }.to change { user.addresses.count }.by(1)
  end

  context 'form invalid' do
    it 'returns false' do
      user = create(:user)
      form = double(
        valid?: false
      )

      service = Api::V1::CreateAddressService.new(form, user)
      expect(service.call).to eq(false)
      expect { service.call }.to change { Address.count }.by(0)
    end
  end
end
