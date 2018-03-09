describe Panel::PublishHomeService do
  it 'publish' do
    home = create(:home, published: true)
    home2 = create(:home)
    home3 = create(:home, published: true)

    service = Panel::PublishHomeService.new(home2)
    service.call
    expect(home.reload.published).to eq(false)
    expect(home3.reload.published).to eq(false)
    expect(home2.reload.published).to eq(true)
  end
end
