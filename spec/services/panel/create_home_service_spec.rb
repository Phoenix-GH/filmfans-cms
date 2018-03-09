describe Panel::CreateHomeService do
  it 'call' do
    form = double(
      valid?: true,
      contents: [],
      home_attributes: {
        name: 'Name',
        published: true
      }
    )

    service = Panel::CreateHomeService.new(form)
    expect { service.call }.to change(Home, :count).by(1)
  end

  context 'form invalid' do
    it 'returns false' do
      form = double(
        valid?: false
      )

      service = Panel::CreateHomeService.new(form)
      expect(service.call).to eq(false)
      expect{ service.call }.to change(Home, :count).by(0)
    end
  end
end
