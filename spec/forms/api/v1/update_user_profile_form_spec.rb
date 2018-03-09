describe Api::V1::UpdateUserProfileForm do
  let(:picture) {
    File.read("#{Rails.root}/spec/fixtures/files/encoded_picture.txt")
  }

  it 'valid' do
    user_profile_form_params = {
      name: 'name',
      surname: 'surname'
    }

    form = Api::V1::UpdateUserProfileForm.new(user_profile_form_params)

    expect(form.valid?).to eq true
  end

  context 'invalid' do
    it 'name: presence' do
      user_profile_form_params = {
      name: '',
      surname: 'surname'
    }

      form = Api::V1::UpdateUserProfileForm.new(user_profile_form_params)

      expect(form.valid?).to eq false
    end

    it 'surname: presence' do
      user_profile_form_params = {
      name: 'name'
    }

      form = Api::V1::UpdateUserProfileForm.new(user_profile_form_params)

      expect(form.valid?).to eq false
    end
  end
end
