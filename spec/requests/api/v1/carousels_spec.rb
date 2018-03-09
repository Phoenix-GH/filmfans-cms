describe 'Carousels requests' do
  it '/api/v1/carousel/home' do
    create(:category, name: 'Woman')
    create(:category, name: 'Man')

    get '/api/v1/carousel/home'
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(
      ['Trending', 'Man', 'Woman', 'Tv', 'Magazine']
    )
  end
end
