describe ProductsContainerQuery do
  context 'order' do
    it 'by media_owner.name' do
      media_owner = create(:media_owner, name: 'Heidi Klum')
      media_owner2 = create(:media_owner, name: 'Bella Thorne')
      create(:products_container, media_owner: media_owner, name: 'Heidi')
      create(:products_container, media_owner: media_owner2, name: 'Bella')
      results = ProductsContainerQuery.new({
        with_media_owner: true,
        sort: 'media_owners.name'
      }).results
      expect(results.map(&:name)).to eq(['Bella', 'Heidi'])
    end
  end


  context 'filters' do
    it 'by channel presence' do
      channel = build_stubbed(:channel)
      create(:products_container, channel_id: channel.id, name: 'combo')
      create(:products_container, channel: nil)

      results = ProductsContainerQuery.new({ with_channel: true }).results
      expect(results.map(&:name)).to eq(['combo'])
    end

    it 'by media_owner presence(combo)' do
      create(:products_container, media_owner_id: 1, name: 'combo')
      create(:products_container)

      query = ProductsContainerQuery.new({ with_media_owner: true })
      expect(query.results.map(&:name)).to eq(['combo'])
    end

    it 'by media_owner_id' do
      owner = build_stubbed(:media_owner)
      create(:products_container, media_owner: owner, name: 'Bella')
      create(:products_container)

      results = ProductsContainerQuery.new({ media_owner_id: owner.id }).results
      expect(results.map(&:name)).to eq(['Bella'])
    end
  end
end
