describe 'Tv Shows requests' do
  it '/api/v1/tv_shows' do
    tv_show = create :tv_show, title: 'Title'
    tv_show = create :tv_show, title: 'Title2'

    get '/api/v1/tv_shows'
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['Title', 'Title2'])
  end

  it '/api/v1/tv_shows?channel_id=555' do
    channel = create :channel, id: 555
    create :tv_show, title: 'Selected Channel Show', channel_id: channel.id
    create :tv_show, title: 'Another Channel Show'

    get "/api/v1/tv_shows?channel_id=#{channel.id}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['Selected Channel Show'])
  end

  it '/api/v1/tv_shows?page=2&per=2' do
    create_list :tv_show, 2, title: 'First Page Show'
    create :tv_show, title: 'Second Page Show'

    get "/api/v1/tv_shows?page=2&per=2"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['Second Page Show'])
  end

  it '/api/v1/tv_shows/:id' do
    tv_show = create :tv_show, :with_1_season_2_episodes, title: 'Selected Show'

    get "/api/v1/tv_shows/#{tv_show.id}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['name']).to eq('Selected Show')
  end
end
