describe ImageRecognition::SendImageForAnalysisService do
  context 'success' do
    before do
      @image_params = {
        image: File.read("#{Rails.root}/spec/fixtures/files/encoded_picture.txt"),
        image_parameters: {
          height: 703,
          width: 391,
          x: 160,
          y: 0
        }
      }
    end

    xit 'call' do
      service = ImageRecognition::SendImageForAnalysisService.new(@image_params)
      crop = service.image_crop
      expect(crop).to eq('160,0,391,703')

      response = service.call
      response = ActiveSupport::JSON.decode(response)
      expect(response['result']).to be_present
    end
  end

  context 'invalid crop parameters' do
    before do
      @image_params = {
        image: File.read("#{Rails.root}/spec/fixtures/files/encoded_picture.txt")
      }
    end

    it 'image crop' do
      service = ImageRecognition::SendImageForAnalysisService.new(@image_params)
      crop = service.image_crop
      expect(crop).to eq('0,0,0,0')
    end
  end
end
