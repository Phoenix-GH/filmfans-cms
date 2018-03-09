describe Panel::UpdateProductFileService do
  xit 'call' do
    product_file = create :product_file
    image = File.open("#{Rails.root}/spec/fixtures/files/my_picture.png")
    form = double(
      valid?: true,
      attributes: { cover_image: image }
    )

    service = Panel::UpdateProductFileService.new(product_file, form)
    expect(service.call).to eq(true)
    expect(product_file.reload.cover_image.present?).to eq true
  end

  context 'form invalid' do
    xit 'returns false' do
      product_file = create :product_file
      form = double(
        valid?: false,
        attributes: { cover_image: '' }
      )

      service = Panel::UpdateProductFileService.new(product_file, form)
      expect(service.call).to eq(false)
      expect(product_file.reload.cover_image.present?).to eq false
    end
  end
end
