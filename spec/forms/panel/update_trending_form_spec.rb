describe Panel::UpdateTrendingForm do
  it 'valid' do
    params = {
      trending_contents: [
        content_id: 1,
        content_type: "MediaContainer"
      ]
    }

    form = Panel::UpdateTrendingForm.new(params)

    expect(form.valid?).to eq true
  end

  context 'invalid' do

  end
end
