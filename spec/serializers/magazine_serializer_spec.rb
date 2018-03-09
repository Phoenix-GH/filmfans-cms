describe MagazineSerializer do
  it 'return' do
    channel = create(:channel, name: 'extra')
    magazine = create :magazine,
      title: 'Title',
      description: 'Description',
      channel: channel

    results = MagazineSerializer.new(magazine).results
    expect(results).to eq(
      {
        id: magazine.id,
        name: 'Title',
        description: 'Description',
        volume_count: 0,
        issues_count: 0,
        cover_image_url: '',
        channel: {
          id: channel.id,
          name: 'extra',
          thumbnail_url: channel.picture.custom_url
        }
      }
    )
  end

  it 'return with volumes' do
    channel = create(:channel, name: 'extra')
    magazine = create :magazine,
      :with_2_volumes,
      title: 'Title',
      description: 'Description',
      channel: channel

    results = MagazineSerializer.new(magazine, with_issues: true).results
    expect(results).to eq(
      {
        id: magazine.id,
        name: 'Title',
        description: 'Description',
        issues_count: 0,
        volume_count: 2,
        cover_image_url: '',
        channel: {
          id: channel.id,
          name: 'extra',
          thumbnail_url: channel.picture.custom_url
        },
        volumes: [
          {
            volume_id: magazine.volumes.first.id.to_i,
            volume_year: magazine.volumes.first.year.to_i,
            volume_issues_count: 0,
            issues: []
          },{
            volume_id: magazine.volumes.last.id.to_i,
            volume_year: magazine.volumes.last.year.to_i,
            volume_issues_count: 0,
            issues: []
          }
        ]
      }
    )
  end
end
