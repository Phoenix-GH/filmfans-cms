describe IssueSerializer do
  it 'return' do
    volume = create :volume, year: 2001
    issue = create :issue, :with_cover_image, volume_id: volume.id,
      publication_date: Date.parse('2001-02-03'), description: 'Issue description', url: 'www.sample.com', pages: 999

    results = IssueSerializer.new(issue).results

    expect(results).to eq(
      {
        issue_id: issue.id.to_i,
        issue_publication_month: 'February',
        issue_publication_year: 2001,
        issue_description: 'Issue description',
        issue_title: '',
        issue_cover_image_url: issue.cover_image.custom_url,
        issue_url: 'www.sample.com',
        issue_pages: 999
      }
    )
  end

  it 'missing values' do
    issue = build :issue, publication_date: nil, description: nil, url: nil, pages: nil
    results = IssueSerializer.new(issue).results

    expect(results).to eq(
      {
        issue_id: 0,
        issue_publication_month: '',
        issue_publication_year: 0,
        issue_description: '',
        issue_title: '',
        issue_cover_image_url: '',
        issue_url: '',
        issue_pages: 0
      }
    )
  end
end
