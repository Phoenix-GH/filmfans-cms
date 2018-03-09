describe Panel::Wizards::UpdateProductSimilarsForm do
  it 'valid for update' do
    similar_products_attributes = {
      similar_products_attributes: {1 => { product_to_id: 1, _destroy: 'false' }}
    }
    similar_products_form_params = {
      similar_products_attributes: {1 => { product_to_id: 1, _destroy: 'false' },
        2 => { product_to_id: 2, _destroy: 'false' }}
    }

    form = Panel::Wizards::UpdateProductSimilarsForm.new(
      similar_products_attributes,
      similar_products_form_params
    )

    expect(form.valid?).to eq true
    expect(form.similar_products.count).to eq(2)
    expect(form.similar_products[1]['product_to_id']).to eq(2)
  end

  it 'valid for create' do
    similar_products_attributes = {}
    similar_products_form_params = {
      similar_products_attributes: {1 => { product_to_id: 1, _destroy: 'false' },
        2 => { product_to_id: 2, _destroy: 'false' }}
    }

    form = Panel::Wizards::UpdateProductSimilarsForm.new(
      similar_products_attributes,
      similar_products_form_params
    )

    expect(form.valid?).to eq true
    expect(form.similar_products.count).to eq(2)
    expect(form.similar_products[0]['product_to_id']).to eq(1)
  end

end
