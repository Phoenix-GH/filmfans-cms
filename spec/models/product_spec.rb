describe Product do
  describe '.product_files' do
    it 'is valid without product_files' do
      product = create :product
      expect(product.product_files.size).to eq(0)
      expect(product).to be_valid
    end

    it 'returns empty array without product_files' do
      product = create :product
      expect(product.product_files).to eq([])
    end

    it 'can have one product_file' do
      product = create :product, :with_product_file
      expect(product.product_files.size).not_to eq(0)
      expect(product.product_files.size).to eq(1)
      expect(product).to be_valid
    end

    it 'can have more than one product_file' do
      product = create :product, :with_product_files
      expect(product.product_files.size).not_to eq(0)
      expect(product.product_files.size).not_to eq(1)
    end

    context 'have uploaded file' do
      it 'must have id in product_files scope' do
        product = create :product, :with_product_files
        expect(product.product_files.first.id).not_to be_nil
      end

      it 'mush have the same id as product has' do
        product = create :product, :with_product_files
        expect(product.product_files.map(&:id).uniq).to eq([product.id])
      end

    end

  end
end
