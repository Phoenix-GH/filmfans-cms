describe VariantFileSerializer do
  it 'return' do
    variant_file = create(:variant_file,
      small_version_url: 'http://small_image.jpg',
      normal_version_url: 'http://normal_image.jpg',
      large_version_url: 'http://large_image.jpg'
    )
    results = VariantFileSerializer.new(variant_file).results

    expect(results).to eq(
      {
        image: 'http://large_image.jpg',
        small_image: 'http://small_image.jpg',
        medium_image: 'http://normal_image.jpg'
      }
    )
  end

  it 'missing values' do
    variant_file = create(:variant_file,
      small_version_url: nil,
      normal_version_url: nil,
      large_version_url: nil
    )
    results = VariantFileSerializer.new(variant_file).results
    expect(results).to eq(
      {
        image: '',
        small_image: '',
        medium_image: ''
      }
    )
  end
end
