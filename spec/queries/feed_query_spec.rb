describe FeedQuery do
  it 'default order by created_at' do
    create(
      :products_container,
      name: 'yesterday',
      created_at: Date.yesterday,
      media_owner: build_stubbed(:media_owner)
    )
    create(
      :products_container,
      name: 'week ago',
      created_at: Date.today - 7.days,
      media_owner: build_stubbed(:media_owner)
    )
    create(:media_container, name: 'today', created_at: Date.today)
    create(:media_container, name: 'two days ago', created_at: Date.today - 2.days)

    results = FeedQuery.new({}).results
    expect(results.map(&:name)).to eq(['today', 'yesterday', 'two days ago', 'week ago'])
  end
end
