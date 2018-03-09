describe 'Magazines requests' do
  it '/api/v1/magazines' do
    magazine = create :magazine, title: 'Title'
    magazine = create :magazine, title: 'Title2'

    get '/api/v1/magazines'
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['Title', 'Title2'])
  end

  it '/api/v1/magazines?channel_id=555' do
    channel = create :channel, id: 555
    create :magazine, title: 'Selected Channel Magazine', channel_id: channel.id
    create :magazine, title: 'Another Channel Magazine'

    get "/api/v1/magazines?channel_id=#{channel.id}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['Selected Channel Magazine'])
  end

  it '/api/v1/magazines?channel_id=555&page=2&per=2' do
    channel = create :channel, id: 555
    create_list :magazine, 2, title: 'First Page Magazine', channel_id: channel.id
    create :magazine, title: 'Second Page Magazine', channel_id: channel.id

    get "/api/v1/magazines?channel_id=555&page=2&per=2"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['Second Page Magazine'])
  end

  it '/api/v1/magazines/:id' do
    magazine = create :magazine, :with_1_volume_2_issues, title: 'Selected Magazine'

    get "/api/v1/magazines/#{magazine.id}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['name']).to eq('Selected Magazine')
  end
end
