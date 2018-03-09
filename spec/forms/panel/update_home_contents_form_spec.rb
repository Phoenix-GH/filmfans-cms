describe Panel::UpdateHomeContentsForm do
  it 'valid' do
    params = {
      home_contents: [
        content_id: 1,
        content_type: "MediaContainer"
      ]
    }

    form = Panel::UpdateHomeContentsForm.new(params)

    expect(form.valid?).to eq true
  end

  context 'invalid' do

  end
end
