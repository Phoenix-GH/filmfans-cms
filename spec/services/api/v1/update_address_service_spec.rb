describe Api::V1::UpdateAddressService do
  it 'call' do
    address = create(:address, city: 'Warsaw', user: create(:user))
    form = double(
      valid?: true,
      address_attributes: { city: 'London' }
    )

    service = Api::V1::UpdateAddressService.new(address, form)
    expect(service.call).to eq true
    expect(address.reload.city).to eq 'London'
  end

  it 'set primary address' do
    user = create(:user)
    address = create(:address, city: 'Warsaw', primary: true, user: user)
    address2 = create(:address, city: 'Kraków', primary: false, user: user)
    form = double(
      valid?: true,
      address_attributes: { primary: false }
    )

    service = Api::V1::UpdateAddressService.new(address, form)
    expect(service.call).to eq true
    expect(address2.reload.primary).to eq(true)
    expect(address.reload.primary).to eq(false)
  end

  it 'set other as primary address' do
    user = create(:user)
    address = create(:address, city: 'Warsaw', primary: false, user: user)
    address2 = create(:address, city: 'Kraków', primary: true, user: user)
    form = double(
      valid?: true,
      address_attributes: { primary: true }
    )

    service = Api::V1::UpdateAddressService.new(address, form)
    expect(service.call).to eq true
    expect(address.reload.primary).to eq(true)
    expect(address2.reload.primary).to eq(false)
  end

  it 'don\'t change when primary exist' do
    user = create(:user)
    address = create(:address, primary: false, user: user)
    address2 = create(:address, primary: false, user: user)
    address3 = create(:address, primary: true, user: user)
    form = double(
      valid?: true,
      address_attributes: { primary: false }
    )

    service = Api::V1::UpdateAddressService.new(address, form)
    expect(service.call).to eq true
    expect(address.reload.primary).to eq(false)
    expect(address2.reload.primary).to eq(false)
    expect(address3.reload.primary).to eq(true)
  end

  it 'set primary address for first address' do
    user = create(:user)
    address = create(:address, city: 'Warsaw', primary: true, user: user)
    form = double(
      valid?: true,
      address_attributes: { primary: false }
    )

    service = Api::V1::UpdateAddressService.new(address, form)
    expect(service.call).to eq true
    expect(address.reload.primary).to eq(true)
  end

  context 'form invalid' do
    it 'returns false' do
      address = create :address, city: 'Warsaw'
      form = double(
        valid?: false
      )

      service = Api::V1::UpdateAddressService.new(address, form)
      expect(service.call).to eq false
    end
  end
end
