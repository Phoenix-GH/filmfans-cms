describe 'Homes requests' do
  context '/api/v1/homes/current' do
    it '/api/v1/homes/current' do
      home = create(:home, published: true, home_type: 'trending')
      create(:home, published: true, home_type: 'woman')
      create(:home, published: false)

      #data important for api-blueprint
      collections_container = build(
        :collections_container,
        name: 'collections',
        collections: [build(:collection)]
      )
      products_container = build(
        :products_container,
        name: 'products container',
        products: [build(:product)]
      )
      combo_container = build(
        :products_container,
        name: 'combo container',
        products: [build(:product)],
        media_content: build(:media_content),
        media_owner: build(:media_owner)
      )
      events_container = create(
        :events_container,
        name: 'Event Container Name',
        events: [build(:event)]
      )
      product = build(
        :product,
        name: 'Name of the Product'
      )
      product2 = build(
        :product,
        name: 'Another Product Name'
      )
      celebrity_link = create(
        :link,
        target: build(
          :media_owner,
          name: 'Celebrity Name'
        )
      )
      channel_link = create(
        :link,
        target: create(
          :channel,
          :with_video_container,
          name: 'Channel Name'
        )
      )
      magazine_link = create(
        :link,
        target: build(
          :magazine,
          :with_cover_image,
          title: 'Magazine title'
        )
      )
      tv_show_link = create(
        :link,
        target: create(
          :tv_show,
          :with_cover_image,
          :with_1_season_2_episodes,
          title: 'Tv Show title'
        )
      )
      celeb_media_container = build(
        :media_container,
        name: 'media container',
        media_content: build(:media_content, :with_file_type_image),
        owner: build(:media_owner)
      )
      channel_media_container = build(
        :media_container,
        name: 'media container',
        media_content: build(:media_content, :with_file_type_image),
        owner: build(:channel)
      )

      #relations and position
      create(
        :home_content,
        home: home,
        content: collections_container,
        position: 2,
        width: 'full'
      )
      create(
        :home_content,
        home: home,
        content: products_container,
        position: 1,
        width: 'full'
      )
      create(
        :home_content,
        home: home,
        content: celeb_media_container,
        position: 3,
        width: 'half'
      )
      create(
        :home_content,
        home: home,
        content: channel_media_container,
        position: 11,
        width: 'full'
      )
      create(
        :home_content,
        home: home,
        content: combo_container,
        position: 4,
        width: 'half'
      )
      create(
        :home_content,
        home: home,
        content: product,
        position: 5,
        width: 'full'
      )
      create(
        :home_content,
        home: home,
        content: product2,
        position: 10,
        width: 'full'
      )
      create(
        :home_content,
        home: home,
        content: celebrity_link,
        position: 6,
        width: 'full'
      )
      create(
        :home_content,
        home: home,
        content: channel_link,
        position: 7,
        width: 'half'
      )
      create(
        :home_content,
        home: home,
        content: magazine_link,
        position: 8,
        width: 'half'
      )
      create(
        :home_content,
        home: home,
        content: tv_show_link,
        position: 9,
        width: 'full'
      )
      create(
        :home_content,
        home: home,
        content: events_container,
        position: 12,
        width: 'full'
      )

      get "/api/v1/homes/current"
      body = ActiveSupport::JSON.decode(response.body)
      expect(body.count).to eq(8)
      expect(body['home_type']).to eq('trending')
      expect(body['products_containers'][0]['name']).to eq('products container')
      expect(body['events_containers'][0]['name']).to eq('Event Container Name')
      expect(body['collections_containers'][0]['name']).to eq('collections')
      expect(body['media_containers'][0]['name']).to eq('media container')
      expect(body['combo_containers'][0]['name']).to eq('combo container')
      expect(body['single_product_containers'][0]['name']).to eq('Name of the Product')
      expect(body['links_containers'][0]['name']).to eq('Celebrity Name')
      expect(body['links_containers'][1]['name']).to eq('Channel Name')
      expect(body['links_containers'][2]['name']).to eq('Magazine title')
      expect(body['links_containers'][3]['name']).to eq('Tv Show title')
    end

    it '/api/v1/homes/current?home_type=man' do
      home = create(:home, published: true, home_type: 'man')
      create(:home, published: true, home_type: 'woman')
      create(:home, published: false)

      collections_container = build(
        :collections_container,
        name: 'collections',
        collections: [build(:collection)]
      )

      products_container = build(
        :products_container,
        name: 'products container',
        products: [build(:product)],
      )

      combo_container = build(
        :products_container,
        name: 'combo container',
        products: [build(:product)],
        media_content: build(:media_content),
        media_owner: build(:media_owner)
      )

      media_container = build(
        :media_container,
        name: 'media container',
        media_content: build(:media_content, :with_file_type_image)
      )

      #relations and position
      create(
        :home_content,
        home: home,
        content: collections_container,
        position: 2
      )
      create(
        :home_content,
        home: home,
        content: products_container,
        position: 1
      )
      create(
        :home_content,
        home: home,
        content: media_container,
        position: 3
      )
      create(
        :home_content,
        home: home,
        content: combo_container,
        position: 4
      )

      get "/api/v1/homes/current", {
        home_type: 'man'
      }
      body = ActiveSupport::JSON.decode(response.body)
      expect(body.count).to eq(8)
      expect(body['home_type']).to eq('man')
      expect(body['products_containers'][0]['name']).to eq('products container')
      expect(body['collections_containers'][0]['name']).to eq('collections')
      expect(body['media_containers'][0]['name']).to eq('media container')
      expect(body['combo_containers'][0]['name']).to eq('combo container')
    end
  end
end
