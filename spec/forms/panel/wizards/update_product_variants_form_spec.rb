describe Panel::Wizards::UpdateProductVariantsForm do

  it 'valid' do
    product_attributes = {
        id: 1
    }
    product_form_params = { variants_attributes: { 1 => { color: 'black' }, 2 => { color: 'gold' } } }

    form = Panel::Wizards::UpdateProductVariantsForm.new(
        product_attributes,
        product_form_params
    )

    expect(form.variants.length).to eq 2
  end

  it 'valid: with _destroy: "true"' do
    product_attributes = {
        id: 1
    }
    product_form_params = { variants_attributes: { 1 => { color: 'black' }, 2 => { color: 'gold', _destroy: 'true' } } }

    form = Panel::Wizards::UpdateProductVariantsForm.new(
        product_attributes,
        product_form_params
    )

    expect(form.variants.length).to eq 1
  end

end
