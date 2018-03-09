describe ProductQuery do
  context 'order' do
    it 'by name alphabetically' do
      create(:product, name: 'First')
      create(:product, name: 'Second')

      results = ProductQuery.new.results
      expect(results.map(&:name)).to eq(['First', 'Second'])
    end
  end

  context 'filters' do
    it 'category_filter' do
      category = create(:category)
      product = create(:product, name: 'With category', category_ids: category.id)
      create(:product, name: 'Without category')

      results = ProductQuery.new({ category_id: category.id }).results
      expect(results.map(&:name)).to eq(['With category'])
    end

    it 'category_hierarchy_filter' do
      create(:product, category_hierarchy: ["Clothing, Shoes \u0026 Jewelry","Men","Jewelry","Tie Clips"], name: 'product')
      create(:product, category_hierarchy: ["Clothing, Shoes \u0026 Jewelry","Men","Watches","Watch Bands"], name: 'product2')

      results = ProductQuery.new({ category_hierarchy: ["Clothing, Shoes \u0026 Jewelry","Men","Jewelry","Tie Clips"] }).results
      expect(results.map(&:name)).to eq(['product'])
    end

    it 'brand_filter' do
      product = create(:product, name: 'product1', brand: 'nike')
      create(:product, name: 'product2')

      results = ProductQuery.new({ brand: product.brand }).results
      expect(results.map(&:name)).to eq(['product1'])
    end

    it 'vendor_filter' do
      store = create(:store, name: 'Amazon')
      product = create(:product, name: 'product')
      product2 = create(:product)
      variant = create(:variant, product: product, description: 'asd')
      create(:variant_store, variant: variant, store: store)

      Product.reindex
      Product.searchkick_index.refresh

      results = ProductQuery.new({ vendor: store.name }).results
      expect(results.map(&:name)).to eq(['product'])
    end

    it 'nonexistent_category filter' do
      category = create(:category)
      create(:product, name: 'With category', category_ids: category.id)
      create(:product, name: 'Without category')

      results = ProductQuery.new({ category_id: 0 }).results
      expect(results).to eq([])
    end

    it 'nonexistent_channel filter' do
      channel = create :channel
      product = create(:product, name: 'With channel')
      create(:product, name: 'Without channel')

      products_container = create :products_container, channel_id: channel.id
      create :linked_product, product_id: product.id, products_container_id: products_container.id

      results = ProductQuery.new({ channel_id: 0 }).results
      expect(results).to eq([])
    end

    it 'nonexistent_media_owner filter' do
      media_owner = create :media_owner
      product = create(:product, name: 'With media owner')
      create(:product, name: 'Without media owner')

      products_container = create :products_container, media_owner_id: media_owner.id
      create :linked_product, product_id: product.id, products_container_id: products_container.id

      results = ProductQuery.new({ media_owner_id: 0 }).results
      expect(results).to eq([])
    end

    it 'products_ids filter' do
      product = create(:product, name: 'Selected product 1')
      product2 = create(:product, name: 'Selected product 2')
      create(:product, name: 'Other product')

      results = ProductQuery.new({ product_ids: [product.id, product2.id] }).results
      expect(results.map(&:name)).to eq(['Selected product 1', 'Selected product 2'])
    end

    it 'filter by category, channels or media_owners' do
      category = create :category
      channel = create :channel
      media_owner = create :media_owner

      product = create(:product, name: 'With category and channel', category_ids: category.id)
      create(:product, name: 'Without category')
      create(:product, name: 'With category but without channel/media_owner', category_ids: category.id)
      product3 = create(:product, name: 'With category and media_owner', category_ids: category.id)
      products_container = create :products_container, channel_id: channel.id
      create :linked_product, product_id: product.id, products_container_id: products_container.id

      products_container2 = create :products_container, media_owner_id: media_owner.id
      create :linked_product, product_id: product3.id, products_container_id: products_container2.id

      results = ProductQuery.new({ category_id: [category.id], channel_id: [channel.id], media_owner_id: [media_owner.id] }).results
      expect(results.map(&:name)).to eq(['With category and channel', 'With category and media_owner'])
    end
  end
end
