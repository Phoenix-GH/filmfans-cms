describe VolumeSerializer do
  it 'return' do
    volume = create :volume, year: 1998
    create_list :issue, 2, volume_id: volume.id, publication_date: Date.parse('1998-08-08')
    results = VolumeSerializer.new(volume).results

    expect(results).to eq(
      {
        volume_id: volume.id.to_i,
        volume_year: 1998,
        volume_issues_count: 2,
        issues: [
          {
            issue_id: volume.issues.first.id.to_i,
            issue_publication_month: 'August',
            issue_publication_year: 1998,
            issue_description: volume.issues.first.description.to_s,
            issue_title: '',
            issue_cover_image_url: '',
            issue_url: volume.issues.first.url.to_s,
            issue_pages: volume.issues.first.pages.to_i
          },{
            issue_id: volume.issues.last.id.to_i,
            issue_publication_month: 'August',
            issue_publication_year: 1998,
            issue_description: volume.issues.last.description.to_s,
            issue_title: '',
            issue_cover_image_url: '',
            issue_url: volume.issues.last.url.to_s,
            issue_pages: volume.issues.last.pages.to_i
          }
        ]
      }
    )
  end

  it 'missing values' do
    volume = build :volume, year: nil
    results = VolumeSerializer.new(volume).results

    expect(results).to eq(
      {
        volume_id: 0,
        volume_year: 0,
        volume_issues_count: 0,
        issues: []
      }
    )
  end
end
