describe ImageRecognition::SnapProductsFromJsonService do
  before(:all) do
    @json = File.read("#{Rails.root}/spec/fixtures/files/babak_200_response.json")
  end

  before(:each) do
    @product_snapped_before = create :product, id: 1, name: 'Product 1'
    create :product, id: 2, name: 'Product 2'
    create :product, id: 3, name: 'Product 3'
    create :product, id: 5, name: 'Product 5'
  end

  context 'guest user' do
    before do
      @json = File.read("#{Rails.root}/spec/fixtures/files/babak_200_response.json")
    end

    it 'returns snapped products array' do
      service = ImageRecognition::SnapProductsFromJsonService.new(@json, nil)
      service.call

      expect(service.man_products.map(&:name)).to eq(["Product 1", "Product 2"])
      expect(service.woman_products.map(&:name)).to eq(["Product 3"])
    end

    it 'does not save snapped products in db' do
      service = ImageRecognition::SnapProductsFromJsonService.new(@json, nil)

      expect { service.call }.to change { SnappedProduct.count }.by(0)
    end
  end

  context 'current user' do
    before do
      @json = File.read("#{Rails.root}/spec/fixtures/files/babak_200_response.json")
    end

    it 'saves snapped products in db' do
      user = create :user
      create :snapped_product, product: @product_snapped_before, user: user

      service = ImageRecognition::SnapProductsFromJsonService.new(@json, user.id)
      expect { service.call }.to change { SnappedProduct.count }.by(3)
    end
  end

  context 'wrong user id' do
    before do
      @json = File.read("#{Rails.root}/spec/fixtures/files/babak_200_response.json")
    end

    it 'returns snapted products array' do
      service = ImageRecognition::SnapProductsFromJsonService.new(@json, 114)
      service.call

      expect(service.man_products.map(&:name)).to eq(["Product 1", "Product 2"])
      expect(service.woman_products.map(&:name)).to eq(["Product 3"])
    end

    it 'does not save snapped products in db' do
      service = ImageRecognition::SnapProductsFromJsonService.new(@json, 114)

      expect { service.call }.to change { SnappedProduct.count }.by(0)
    end
  end

  context 'invalid request' do
    before do
      @json = File.read("#{Rails.root}/spec/fixtures/files/babak_422_response.json")
    end

    it 'returns snapted products array' do
      service = ImageRecognition::SnapProductsFromJsonService.new(@json, nil)
      service.call

      expect(service.man_products).to eq([])
      expect(service.woman_products).to eq([])
    end
  end
end
