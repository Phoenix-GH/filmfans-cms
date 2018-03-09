describe Panel::CreateFileModelCoverImageService do
  context 'media_content' do
    it 'call' do
      media_content = create :media_content, :with_file_type_image
      expect(media_content.cover_image.file).to be_nil
      Panel::CreateFileModelCoverImageService.new(media_content).call
      expect(media_content.cover_image.file).to be_present
    end
  end

  context 'product file' do
    xit 'call' do
      product_file = create :product_file, :with_file_type_image
      expect(product_file.cover_image.file).to be_nil
      Panel::CreateFileModelCoverImageService.new(product_file).call
      expect(product_file.cover_image.file).to be_present
    end
  end
end
