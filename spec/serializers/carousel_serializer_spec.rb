describe CarouselSerializer do
  it 'returns' do
    stub_const(
      'ENV', {
        'CAROUSEL_ICONS_TV'=>'s3_tv_url',
        'CAROUSEL_ICONS_MAGAZINE'=>'s3_magazine_url',
        'CAROUSEL_ICONS_TRENDING'=>'s3_trending_url'
      }
    )
    woman_category = create(
      :category,
      :with_icon,
      name: 'Woman'
    )
    woman_shoes_category = create(
      :category,
      name: 'Woman Shoes',
      parent_id: woman_category.id
    )
    results = CarouselSerializer.new.results

    expect(results).to eq(
      [
        {
          name: 'Trending',
          icon_url: 's3_trending_url',
          type: 'trending'
        },
        {
          id: woman_category.id,
          name: 'Woman',
          icon_url: woman_category.icon.carousel.url,
          subcategories: [
            {
              id: woman_shoes_category.id,
              name: 'Woman Shoes',
              icon_url: CategoryUploader.new.carousel.default_url,
              subcategories: []
            }
          ],
          type: 'category'
        },
        {
          name: 'Tv',
          icon_url: 's3_tv_url',
          type: 'tv'
        },
        {
          name: 'Magazine',
          icon_url: 's3_magazine_url',
          type: 'magazine'
        }
      ]
    )
  end

  it 'missing_values' do
    stub_const(
      'ENV', {
        'CAROUSEL_ICONS_TV'=>nil,
        'CAROUSEL_ICONS_MAGAZINE'=>nil,
        'CAROUSEL_ICONS_TRENDING'=>nil
      }
    )
    results = CarouselSerializer.new.results
    expect(results).to eq(
      [
        {
          name: 'Trending',
          icon_url: '',
          type: 'trending'
        },
        {
          name: 'Tv',
          icon_url: '',
          type: 'tv'
        },
        {
          name: 'Magazine',
          icon_url: '',
          type: 'magazine'
        }
      ]
    )
  end
end
