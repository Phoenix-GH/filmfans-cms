describe ProductFile do
  describe '#small_cover_image_url' do
    it 'cover image present: returns small thumb version' do
      product_file = create :product_file, :with_file_type_image, :with_cover_image
      expect(product_file.small_cover_image_url).to match(/\/small_thumb_my_picture_.*.png/)
    end

    it 'cover image absent: returns small version url' do
      product_file = create :product_file, small_version_url: 'http://small_image.jpg'
      expect(product_file.small_cover_image_url).to eq('http://small_image.jpg')
    end

    it 'everything is empty: returns empty string' do
      product_file = create :product_file
      expect(product_file.small_cover_image_url).to eq ''
    end
  end

  describe '#thumb_cover_image_url' do
    it 'cover image present: returns thumb version' do
      product_file = create :product_file, :with_file_type_image, :with_cover_image
      expect(product_file.thumb_cover_image_url).to match(/\/thumb_my_picture.*.png/)
    end

    it 'cover image absent: returns normal version url' do
      product_file = create :product_file, normal_version_url: 'http://normal_image.jpg'
      expect(product_file.thumb_cover_image_url).to eq('http://normal_image.jpg')
    end

    it 'everything is empty: returns empty string' do
      product_file = create :product_file
      expect(product_file.thumb_cover_image_url).to eq ''
    end
  end

  describe '#large_cover_image_url' do
    it 'cover image present: returns image' do
      product_file = create :product_file, :with_file_type_image, :with_cover_image
      expect(product_file.large_cover_image_url).to match(/\/my_picture.*.png/)
    end

    it 'cover image absent: returns large version url' do
      product_file = create :product_file, large_version_url: 'http://large_image.jpg'
      expect(product_file.large_cover_image_url).to eq('http://large_image.jpg')
    end

    it 'everything is empty: returns empty string' do
      product_file = create :product_file
      expect(product_file.large_cover_image_url).to eq ''
    end
  end
end
