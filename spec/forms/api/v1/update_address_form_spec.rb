describe Api::V1::UpdateAddressForm do
  it 'valid' do
    address_attributes = {
      label: 'label',
      city: 'city',
      street: 'street 345',
      zip_code: '12-123',
      country: 'Poland',
      primary: '0'
    }
    address_form_params = { street: 'street 123' }

    form = Api::V1::UpdateAddressForm.new(
      address_attributes,
      address_form_params
    )

    expect(form.valid?).to eq true
    expect(form.street).to eq 'street 123'
  end

  context 'invalid' do
    it 'city:presence' do
      address_attributes = {
        label: 'label',
        city: 'city',
        street: 'street 345',
        zip_code: '12-123',
        country: 'Poland',
        primary: '1'
      }
      address_form_params = { city: '' }

      form = Api::V1::UpdateAddressForm.new(
        address_attributes,
        address_form_params
      )

      expect(form.valid?).to eq false
    end

    it 'street:presence' do
      address_attributes = {
        label: 'label',
        city: 'city',
        street: 'street 345',
        zip_code: '12-123',
        country: 'Poland',
        primary: '1'
      }
      address_form_params = { street: '' }

      form = Api::V1::UpdateAddressForm.new(
        address_attributes,
        address_form_params
      )

      expect(form.valid?).to eq false
    end

    it 'zip_code:presence' do
      address_attributes = {
        label: 'label',
        city: 'city',
        street: 'street 345',
        zip_code: '12-123',
        country: 'Poland',
        primary: '1'
      }
      address_form_params = { zip_code: '' }

      form = Api::V1::UpdateAddressForm.new(
        address_attributes,
        address_form_params
      )

      expect(form.valid?).to eq false
    end

    it 'country:presence' do
      address_attributes = {
        label: 'label',
        city: 'city',
        street: 'street 345',
        zip_code: '12-123',
        country: 'Poland',
        primary: '1'
      }
      address_form_params = { country: '' }

      form = Api::V1::UpdateAddressForm.new(
        address_attributes,
        address_form_params
      )

      expect(form.valid?).to eq false
    end

    it 'primary flag:inclusion' do
      address_attributes = {
        label: 'label',
        city: 'city',
        street: 'street 345',
        zip_code: '12-123',
        country: 'Poland',
        primary: '1'
      }
      address_form_params = { primary: '' }

      form = Api::V1::UpdateAddressForm.new(
        address_attributes,
        address_form_params
      )

      expect(form.valid?).to eq false
    end

  end
end
