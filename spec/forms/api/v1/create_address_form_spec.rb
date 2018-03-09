describe Api::V1::CreateAddressForm do
  it 'valid' do
    params = {
      city: 'city',
      label: 'label',
      street: 'Street 123',
      zip_code: '15-111',
      country: 'Poland',
      primary: '1'
    }

    form = Api::V1::CreateAddressForm.new(params)

    expect(form.valid?).to eq true
  end

  context 'invalid' do
    it 'city:presence' do
      params = {
        city: '',
        label: 'label',
        street: 'Street 123',
        zip_code: '15-111',
        country: 'Poland',
        primary: '0'
      }

      form = Api::V1::CreateAddressForm.new(params)

      expect(form.valid?).to eq false
    end

    it 'street:presence' do
      params = {
        city: 'city',
        label: 'label',
        street: '',
        zip_code: '15-111',
        country: 'Poland',
        primary: '0'
      }

      form = Api::V1::CreateAddressForm.new(params)

      expect(form.valid?).to eq false
    end

    it 'zip_code:presence' do
      params = {
        city: 'city',
        label: 'label',
        street: 'Street 123',
        zip_code: '',
        country: 'Poland',
        primary: '0'
      }

      form = Api::V1::CreateAddressForm.new(params)

      expect(form.valid?).to eq false
    end

    it 'country:presence' do
      params = {
        city: 'city',
        label: 'label',
        street: 'Street 123',
        zip_code: '15-111',
        country: '',
        primary: '0'
      }

      form = Api::V1::CreateAddressForm.new(params)

      expect(form.valid?).to eq false
    end

    it 'primary:inclusion' do
      params = {
        city: '',
        label: 'label',
        street: 'Street 123',
        zip_code: '15-111',
        country: 'Poland'
      }

      form = Api::V1::CreateAddressForm.new(params)

      expect(form.valid?).to eq false
    end
  end
end
