describe Panel::UpdateHomeContentsService do
  it "create new home contents" do
    home = create(:home)
    media_container = create(:media_container)
    products_container = create(:products_container)

    form = double(
      valid?: true,
      home_contents: [
        OpenStruct.new(
          content_id: media_container.id,
          content_type: "MediaContainer"
        ),
        OpenStruct.new(
          content_id: products_container.id,
          content_type: "ProductsContainer"
      )]
    )

    expect{
      Panel::UpdateHomeContentsService.new(home, form).call
    }.to change(HomeContent, :count).by(2)
  end

  it "remove old home contents" do
    home = create(:home)
    media_container = create(:media_container)
    products_container = create(:products_container)
    products_container2 = create(:products_container)
    create(:home_content, home: home, content: media_container)
    create(:home_content, home: home, content: products_container)

    form = double(
      valid?: true,
      home_contents: [
        OpenStruct.new(
          content_id: media_container.id,
          content_type: "MediaContainer"
        ),
        OpenStruct.new(
          content_id: products_container2.id,
          content_type: "ProductsContainer"
      )]
    )

    Panel::UpdateHomeContentsService.new(home, form).call
    expect(
      HomeContent.where(home: home, content: media_container).any?
    ).to be true
    expect(
      HomeContent.where(home: home, content: products_container).any?
    ).to be false
    expect(
      HomeContent.where(home: home, content: products_container2).any?
    ).to be true
  end
end
