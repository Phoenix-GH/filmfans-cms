describe 'Snapped products requests' do
  it '/api/v1/snapped_products/' do
    user = create(:user)
    product = create(:product, name: 'Product')
    product2 = create(:product, name: 'Product2')
    product3 = create(:product, name: 'Product3')
    create(:product, name: 'Product3')
    user_auth_header = user.create_new_auth_token(user.tokens.keys[0])

    create(:snapped_product, user: user, product_id: product.id)
    create(:snapped_product, user: user, product_id: product2.id)
    create(:wishlist, user: user, product_id: product3.id)

    get '/api/v1/snapped_products/', {}, user_auth_header
    body = ActiveSupport::JSON.decode(response.body)

    expect(body.map { |h| h['name'] }).to eq(['Product', 'Product2'])
  end

  context 'guest user' do
    it '/api/v1/snapped_products/' do
      user = create(:user)
      product = create(:product, name: 'Product')
      product2 = create(:product, name: 'Product2')

      create(:snapped_product, user: user, product_id: product.id)
      create(:snapped_product, user: user, product_id: product2.id)

      get '/api/v1/snapped_products/', {}
      body = ActiveSupport::JSON.decode(response.body)

      expect(body['errors']).to eq(['Authorized users only.'])
    end
  end

  context 'capture products from photo' do
    before(:each) do
      create :product, id: 1, name: 'Product 1'
      create :product, id: 2, name: 'Product 2'
      create :product, id: 3, name: 'Product 3'
      create :product, id: 5, name: 'Product 5'
    end

    it '/api/v1/snapped_products/capture' do
      babak_response = File.read("#{Rails.root}/spec/fixtures/files/babak_200_response.json")
      allow_any_instance_of(ImageRecognition::SendImageForAnalysisService).to receive(:call).and_return(babak_response)

      user = create(:user)
      user_auth_header = user.create_new_auth_token(user.tokens.keys[0])
      params = {
        image: File.read("#{Rails.root}/spec/fixtures/files/encoded_picture.txt"),
        image_parameters: {
          height: 703,
          width: 391,
          x: 160,
          y: 0
        }
      }

      expect(SaveSnappedPhotoWorker).to receive(:perform_async)

      post '/api/v1/snapped_products/capture', params, user_auth_header
      body = ActiveSupport::JSON.decode(response.body)

      expect(body['man'].map { |h| h['name'] }).to eq(['Product 1', 'Product 2'])
      expect(body['woman'].map { |h| h['name'] }).to eq(['Product 3'])
    end

    context 'photo not to be saved' do
      it '/api/v1/snapped_products/capture' do
        babak_response = File.read("#{Rails.root}/spec/fixtures/files/babak_200_response.json")
        allow_any_instance_of(ImageRecognition::SendImageForAnalysisService).to receive(:call).and_return(babak_response)

        user = create(:user)
        user_auth_header = user.create_new_auth_token(user.tokens.keys[0])

        params = {
          image: File.read("#{Rails.root}/spec/fixtures/files/encoded_picture.txt"),
          do_not_save: true,
          image_parameters: {
            height: 703,
            width: 391,
            x: 160,
            y: 0
          }
        }

        expect(SaveSnappedPhotoWorker).not_to receive(:perform_async)

        post '/api/v1/snapped_products/capture', params, user_auth_header
        body = ActiveSupport::JSON.decode(response.body)

        expect(body['man'].map { |h| h['name'] }).to eq(['Product 1', 'Product 2'])
        expect(body['woman'].map { |h| h['name'] }).to eq(['Product 3'])
      end
    end

    context 'guest user' do
      it '/api/v1/snapped_products/capture' do
        babak_response = File.read("#{Rails.root}/spec/fixtures/files/babak_200_response.json")
        allow_any_instance_of(ImageRecognition::SendImageForAnalysisService).to receive(:call).and_return(babak_response)
        params = {
          image: File.read("#{Rails.root}/spec/fixtures/files/encoded_picture.txt"),
          image_parameters: {
            height: 703,
            width: 391,
            x: 160,
            y: 0
          }
        }

        expect(SaveSnappedPhotoWorker).not_to receive(:perform_async)

        post '/api/v1/snapped_products/capture', params
        body = ActiveSupport::JSON.decode(response.body)

        expect(body['man'].map { |h| h['name'] }).to eq(['Product 1', 'Product 2'])
        expect(body['woman'].map { |h| h['name'] }).to eq(['Product 3'])
      end
    end

    context 'wrong parameters' do
      wrong_response = File.read("#{Rails.root}/spec/fixtures/files/babak_422_response.json")
      wrong_params = {
        image: File.read("#{Rails.root}/spec/fixtures/files/empty.txt"),
        image_parameters: {
          width: -10,
          x: 160,
          y: 'abc'
        }
      }
      it '/api/v1/snapped_products/capture' do
        allow_any_instance_of(ImageRecognition::SendImageForAnalysisService).to receive(:call).and_return(wrong_response)
        user = create(:user)
        user_auth_header = user.create_new_auth_token(user.tokens.keys[0])

        expect(SaveSnappedPhotoWorker).to receive(:perform_async)

        post '/api/v1/snapped_products/capture', wrong_params, user_auth_header
        body = ActiveSupport::JSON.decode(response.body)

        expect(body['man']).to eq([])
        expect(body['woman']).to eq([])
      end
    end

    context 'no response' do
      it '/api/v1/snapped_products/capture' do
        allow_any_instance_of(ImageRecognition::SendImageForAnalysisService).to receive(:call).and_return(false)
        params = {
          image: File.read("#{Rails.root}/spec/fixtures/files/encoded_picture.txt"),
          image_parameters: {
            height: 703,
            width: 391,
            x: 160,
            y: 0
          }
        }

        post '/api/v1/snapped_products/capture', params
        body = ActiveSupport::JSON.decode(response.body)

        expect(body['man']).to eq([])
        expect(body['woman']).to eq([])
      end
    end
  end
end
