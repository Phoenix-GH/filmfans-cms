describe OptionValueSerializer do
  it 'return' do
    option_type = create(:option_type, name: 'Color')
    option_value = create(:option_value,
      name: 'red',
      option_type_id: option_type.id
    )
    results = OptionValueSerializer.new(option_value).results

    expect(results).to eq(
      {
        value: 'red',
        option_type: 'Color'
      }
    )
  end

  it 'missing values' do
    option_value = create(:option_value,
      name: nil,
      option_type_id: nil
    )
    results = OptionValueSerializer.new(option_value).results
    expect(results).to eq(
      {
        value: '',
        option_type: ''
      }
    )
  end
end
