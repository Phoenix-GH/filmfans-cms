describe TvShowSeasonSerializer do
  it 'return' do
    season = create :tv_show_season, :with_2_episodes, number: 555
    results = TvShowSeasonSerializer.new(season).results

    expect(results).to eq(
      {
        season_id: season.id.to_i,
        season_number: 555,
        season_episodes_count: 2,
        episodes: [
          {
            episode_id: season.episodes.first.id,
            episode_number: season.episodes.first.number,
            episode_title: season.episodes.first.title,
            episode_cover_image: '',
            episode_file_url: '',
            episode_file_specification: {}
          },{
            episode_id: season.episodes.last.id,
            episode_number: season.episodes.last.number,
            episode_title: season.episodes.last.title,
            episode_cover_image: '',
            episode_file_url: '',
            episode_file_specification: {}
          }
        ]
      }
    )
  end

  it 'missing values' do
    season = build :tv_show_season, number: nil
    results = TvShowSeasonSerializer.new(season).results

    expect(results).to eq(
      {
        season_id: 0,
        season_number: 0,
        season_episodes_count: 0,
        episodes: []
      }
    )
  end

end
