describe Panel::UpdateEventContainersService do
  it "create new event contents" do
    event = create(:event)
    media_container = create(:media_container)
    collections_container = create(:collections_container)

    form = double(
      valid?: true,
      event_contents: [
        OpenStruct.new(
          content_id: media_container.id,
          content_type: "MediaContainer"
        ),
        OpenStruct.new(
          content_id: collections_container.id,
          content_type: "CollectionsContainer"
      )]
    )

    expect{
      Panel::UpdateEventContainersService.new(event, form).call
    }.to change(EventContent, :count).by(2)
  end

  it "remove old event contents" do
    event = create(:event)
    media_container = create(:media_container)
    collections_container = create(:collections_container)
    collections_container2 = create(:collections_container)
    create(:event_content, event: event, content: media_container)
    create(:event_content, event: event, content: collections_container)

    form = double(
      valid?: true,
      event_contents: [
        OpenStruct.new(
          content_id: media_container.id,
          content_type: "MediaContainer"
        ),
        OpenStruct.new(
          content_id: collections_container2.id,
          content_type: "CollectionsContainer"
      )]
    )

    Panel::UpdateEventContainersService.new(event, form).call
    expect(
      EventContent.where(event: event, content: media_container).any?
    ).to be true
    expect(
      EventContent.where(event: event, content: collections_container).any?
    ).to be false
    expect(
      EventContent.where(event: event, content: collections_container2).any?
    ).to be true
  end
end
