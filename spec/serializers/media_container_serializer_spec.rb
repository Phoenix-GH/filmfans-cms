describe MediaContainerSerializer do
  it 'return' do
    media_container = build(
      :media_container,
      :with_media_content,
      name: 'Outfit',
      description: 'New outfit',
      additional_description: 'Super'
    )
    results = MediaContainerSerializer.new(media_container, true).results

    expect(results).to eq(
      {
        type: 'media_container',
        id: media_container.id,
        name: 'Outfit',
        description: 'New outfit',
        additional_description: 'Super',
        date: media_container.created_at.to_i,
        width: 'half',
        owner: {},
        content: '',
        tags: []
      }
    )
  end

  it 'missing values' do
    media_container = build(
      :media_container,
      name: nil,
      description: nil,
      additional_description: nil,
      created_at: nil
    )
    results = MediaContainerSerializer.new(media_container).results
    expect(results).to eq(
      {
        type: 'media_container',
        id: media_container.id,
        name: '',
        description: '',
        additional_description: '',
        date: 0,
        width: 'half',
        owner: {},
        content: ''
      }
    )
  end
end
