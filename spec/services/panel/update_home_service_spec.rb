describe Panel::UpdateHomeService do
  it 'call' do
    home = create(:home, name:'Old name', published: true)
    form = double(
      valid?: true,
      contents: [],
      home_attributes:{
        name: 'New name',
        published: true
      }
    )

    Panel::UpdateHomeService.new(home, form).call
    expect(home.reload.name).to eq 'New name'
  end

  context 'form invalid' do
    it 'returns false' do
      home = create(:home)
      form = double(
        valid?: false
      )

      service = Panel::UpdateHomeService.new(home, form)
      expect(service.call).to eq(false)
    end
  end
end
