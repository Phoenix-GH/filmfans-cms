describe CategorySerializer do
  it 'return' do
    parent_category = build_stubbed(:category)
    category = build(
      :category,
      :with_image,
      :with_icon,
      name: 'Shoes',
      parent_id: parent_category.id,
    )
    results = CategorySerializer.new(category).results

    expect(results).to eq(
      {
        id: category.id,
        parent_id: parent_category.id.to_s,
        name: 'Shoes',
        image: category.image_url.to_s,
        icon: category.icon_url.to_s
      }
    )
  end

  it 'return with subcategories' do
    woman_category = create(:category, name: 'Woman')
    woman_shoes_category = create(
      :category,
      name: 'Woman Shoes',
      parent_id: woman_category.id
    )
    category3 = create(
      :category,
      name: 'Woman Shoes Something',
      parent_id: woman_shoes_category.id
    )
    results = CategorySerializer.new(woman_category, true).results

    expect(results).to eq(
      {
        id: woman_category.id,
        name: 'Woman',
        icon_url: CategoryUploader.new.carousel.default_url,
        subcategories: [
          {
            id: woman_shoes_category.id,
            name: 'Woman Shoes',
            icon_url: CategoryUploader.new.carousel.default_url,
            subcategories: [
              {
                id: category3.id,
                name: 'Woman Shoes Something',
                icon_url: CategoryUploader.new.carousel.default_url,
                subcategories: []
            }]
        }]
      }
    )
  end

  it 'missing values' do
    category = build(
      :category,
      name: nil,
      parent_id: nil,
      image: nil,
      icon: nil
    )
    results = CategorySerializer.new(category).results
    expect(results).to eq(
      {
        id: category.id,
        parent_id: '',
        name: '',
        image: CategoryUploader.new.default_url,
        icon: CategoryUploader.new.default_url
      }
    )
  end
end
