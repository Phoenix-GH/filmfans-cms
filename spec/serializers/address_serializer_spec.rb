describe AddressSerializer do
  it 'return' do
    user = create :user
    address = build(:address, city: 'Warsaw', street: 'Okrzei 23', user: user, primary: false)
    results = AddressSerializer.new(address).results

    expect(results).to eq(
        {
          id: address.id,
          user_id: address.user_id,
          label: address.label,
          city: 'Warsaw',
          street: 'Okrzei 23',
          zip_code: address.zip_code,
          country: address.country,
          primary: 'false'
        }
      )
  end

  it 'missing values' do
    user = create :user
    address = build(:address, city: nil, zip_code: nil, user: user, primary: nil)
    results = AddressSerializer.new(address).results
    expect(results).to eq(
        {
          id: address.id,
          user_id: address.user_id,
          label: address.label,
          city: '',
          street: address.street,
          zip_code: '',
          country: address.country,
          primary: ''
        }
      )
  end
end
