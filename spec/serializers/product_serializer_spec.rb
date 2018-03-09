describe ProductSerializer do
  context 'with uploaded file' do
    it 'return' do
      product = create(
        :product,
        :with_product_file,
        name: 'new product',
        brand: 'Zara',
        description: 'Description',
        vendor_url: 'www.zalando.com/beret',
        price_range: '$20',
        variants: [create(:variant, :with_variant_store)]
      )
      similar_product = build(
        :product,
        name: 'similar product',
        brand: 'Zara',
        description: 'Similar description',
        price_range: '$20 - $25',
        variants: [create(:variant, :with_variant_store)]
      )
      create(:product_similarity, product_from: product, product_to: similar_product)
      results = ProductSerializer.new(product, with_similar_products: true).results

      expect(results).to eq(
        {
          id: product.id,
          name: 'new product',
          brand: 'Zara',
          category: [],
          description: 'Description',
          vendor_url: 'www.zalando.com/beret',
          vendor: 'Amazon',
          image: product.product_files.first.cover_image.url,
          small_image: product.product_files.first.cover_image.small_thumb.url,
          medium_image: product.product_files.first.cover_image.thumb.url,
          price_min: 20.0,
          price_max: 20.0,
          currency: 'USD',
          asin: 'B0012GLDCU',
          available: 1,
          similar_products: [
            {
              id: similar_product.id,
              name: 'similar product',
              brand: 'Zara',
              category: [],
              description: 'Similar description',
              vendor_url: '',
              vendor: 'Amazon',
              image: '',
              small_image: '',
              medium_image: '',
              price_min: 20.0,
              price_max: 25.0,
              currency: 'USD',
              asin: 'B0012GLDCU',
              available: 1
            }
          ]
        }
      )
    end
  end

  context 'with file urls' do
    it 'return' do
      product = create(
        :product,
        :with_product_file_urls,
        name: 'new product',
        brand: 'Zara',
        description: 'Description',
        vendor_url: 'www.zalando.com/beret',
        price_range: '$20'
      )
      similar_product = build(
        :product,
        name: 'similar product',
        brand: 'Zara',
        description: 'Similar description',
        price_range: '$20 - $25'
      )
      create(:product_similarity, product_from: product, product_to: similar_product)
      results = ProductSerializer.new(product, with_similar_products: true).results

      expect(results).to eq(
        {
          id: product.id,
          name: 'new product',
          brand: 'Zara',
          category: [],
          description: 'Description',
          vendor_url: 'www.zalando.com/beret',
          vendor: '',
          image: 'http://large_image.jpg',
          small_image: 'http://small_image.jpg',
          medium_image: 'http://normal_image.jpg',
          price_min: 20.0,
          price_max: 20.0,
          currency: 'USD',
          asin: '',
          available: 1,
          similar_products: [
            {
              id: similar_product.id,
              name: 'similar product',
              brand: 'Zara',
              category: [],
              description: 'Similar description',
              vendor_url: '',
              vendor: '',
              image: '',
              small_image: '',
              medium_image: '',
              price_min: 20.0,
              price_max: 25.0,
              currency: 'USD',
              asin: '',
              available: 1
            }
          ]
        }
      )
    end
  end

  context 'with variants' do
    it 'return' do
      product = create(
        :product,
        :with_product_file_urls,
        name: 'new product',
        brand: 'Zara',
        description: 'Description',
        vendor_url: 'www.zalando.com/beret',
        price_range: '$20'
      )
      similar_product = build(
        :product,
        name: 'similar product',
        brand: 'Zara',
        description: 'Similar description',
        price_range: '$20 - $25'
      )
      store = create(:store, name: 'Store')
      option_type = create(:option_type, name: 'size')
      option_value = create(:option_value, option_type_id: option_type.id, name: 'S')
      variant = create(:variant, product_id: product.id)
      create(:option_value_variant, variant_id: variant.id, option_value_id: option_value.id)
      create(:variant_store,
        price: 122.22,
        currency: 'PLN',
        url: 'www.zalando.com/variants/beret',
        store_id: store.id,
        variant_id: variant.id,
        quantity: 99
      )
      vf = create(:variant_file, :with_urls, variant_id: variant.id)
      vf.save
      variant.variant_files = vf
      variant.save

      create(:product_similarity, product_from: product, product_to: similar_product)
      results = ProductSerializer.new(product, with_variants: true, with_similar_products: true).results

      expect(results).to eq(
        {
          id: product.id,
          name: 'new product',
          brand: 'Zara',
          category: [],
          description: 'Description',
          vendor_url: 'www.zalando.com/beret',
          vendor: 'Store',
          image: 'http://large_image.jpg',
          small_image: 'http://small_image.jpg',
          medium_image: 'http://normal_image.jpg',
          price_min: 20.0,
          price_max: 20.0,
          currency: 'USD',
          asin: variant.sku,
          available: 1,
          similar_products: [
            {
              id: similar_product.id,
              name: 'similar product',
              brand: 'Zara',
              category: [],
              description: 'Similar description',
              vendor_url: '',
              vendor: '',
              image: '',
              small_image: '',
              medium_image: '',
              price_min: 20.0,
              price_max: 25.0,
              currency: 'USD',
              asin: '',
              available: 1
            }
          ],
          variants: [
            id: variant.id,
            description: variant.description,
            sku: variant.sku,
            variant_files: [
              image: 'http://large_image.jpg',
              small_image: 'http://small_image.jpg',
              medium_image: 'http://normal_image.jpg'
            ],
            variant_stores:[
              value: '122.22',
              currency: 'PLN',
              url: 'www.zalando.com/variants/beret',
              quantity: '99',
              store: 'Store'
            ],
            option_values:[
              {
                value: 'S',
                option_type: 'size'
              }
            ]
          ]
        }
      )
    end
  end

  it 'missing values' do
    product = create(
      :product,
      name: nil,
      brand: nil,
      description: nil,
      vendor_url: nil,
      price_range: "Currently unavailable."
    )
    results = ProductSerializer.new(product, with_similar_products: false).results
    expect(results).to eq(
      {
        id: product.id,
        name: '',
        brand: '',
        category: [],
        description: '',
        vendor_url: '',
        vendor: '',
        image: '',
        small_image: '',
        medium_image: '',
        price_min: 0.0,
        price_max: 0.0,
        currency: 'USD',
        asin: '',
        available: 0
      }
    )
  end
end
