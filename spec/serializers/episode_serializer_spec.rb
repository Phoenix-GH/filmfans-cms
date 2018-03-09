describe EpisodeSerializer do
  it 'return' do
    episode = build_stubbed :episode, :with_cover_image, :with_video_file,
      number: 654, title: 'Episode title'

    results = EpisodeSerializer.new(episode).results

    expect(results).to eq(
      {
        episode_id: episode.id,
        episode_number: 654,
        episode_title: 'Episode title',
        episode_cover_image: episode.file.video_thumb.url.to_s,
        episode_file_url: episode.file.url.to_s,
        episode_file_specification: {
          'height'=>180,
          'width'=>320,
          'duration'=>0.976,
          'video_codec'=> 'mpeg4',
          'audio_codec'=> 'aac',
          'valid'=> true
        }
      }
    )
  end

  it 'missing values' do
    episode = build :episode, number: nil, title: nil
    results = EpisodeSerializer.new(episode).results

    expect(results).to eq(
      {
        episode_id: 0,
        episode_number: 0,
        episode_title: '',
        episode_cover_image: '',
        episode_file_url: '',
        episode_file_specification: {}
      }
    )
  end
end
