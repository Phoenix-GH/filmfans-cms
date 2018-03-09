describe TvShowSerializer do
  it 'return' do
    channel = create(:channel, name: 'extra')
    tv_show = create :tv_show,
      title: 'Title',
      description: 'Description',
      channel: channel

    results = TvShowSerializer.new(tv_show).results
    expect(results).to eq(
      {
        id: tv_show.id,
        name: 'Title',
        description: 'Description',
        episodes_count: 0,
        seasons_count: 0,
        thumbnail_url: '',
        channel: {
          id: channel.id,
          name: 'extra',
          thumbnail_url: channel.picture.custom_url
        }
      }
    )
  end

  it 'return with episodes' do
    channel = create(:channel, name: 'extra')
    tv_show = create :tv_show, :with_2_seasons,
      title: 'Title',
      description: 'Description',
      channel: channel


    results = TvShowSerializer.new(tv_show, with_episodes: true).results
    expect(results).to eq(
      {
        id: tv_show.id,
        name: 'Title',
        description: 'Description',
        episodes_count: 0,
        seasons_count: 2,
        thumbnail_url: '',
        channel: {
          id: channel.id,
          name: 'extra',
          thumbnail_url: channel.picture.custom_url
        },
        seasons: [
          {
            season_id: tv_show.seasons.first.id.to_i,
            season_number: tv_show.seasons.first.number.to_i,
            season_episodes_count: 0,
            episodes: []
          },{
            season_id: tv_show.seasons.last.id.to_i,
            season_number: tv_show.seasons.last.number.to_i,
            season_episodes_count: 0,
            episodes: []
          }
        ]
      }
    )
  end
end
