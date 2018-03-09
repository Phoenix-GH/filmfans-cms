describe Panel::Wizards::UpdateVariantForm do

  it 'valid' do
    variant_attributes = {
        color: 'black',
        description: 'lorem ipsum',
        temp_image_ids: [1,2],
        sizes_attributes: {}
    }
    variant_form_params = {
      color: 'gold',
      description: 'lazy dog',
      position: 1,
      temp_image_ids: [2,3],
      sizes_attributes: { 1 => { size: '10', price: '100' }, 2 => { size: '20', price: '200' } }
    }

    form = Panel::Wizards::UpdateVariantForm.new(
        variant_attributes,
        variant_form_params
    )

    expect(form.valid?).to eq true
    expect(form.sizes.length).to eq 2
    expect(form.color).to eq 'gold'
    expect(form.description).to eq 'lazy dog'
    expect(form.position).to eq 1
  end

  it 'valid: with _destroy: "true"' do
    variant_attributes = {
        sizes_attributes: { 1 => { size: '10', price: '100' }, 2 => { size: '20', price: '200' } }
    }
    variant_form_params = {
        color: 'gold',
        description: 'lazy dog',
        temp_image_ids: [2,3],
        sizes_attributes: { 1 => { size: '10', price: '100' }, 2 => { size: '20', price: '200', _destroy: 'true' } }
    }

    form = Panel::Wizards::UpdateVariantForm.new(
        variant_attributes,
        variant_form_params
    )

    expect(form.sizes.length).to eq 1
  end

end
