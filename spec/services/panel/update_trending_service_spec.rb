describe Panel::UpdateTrendingService do
  it "create new trending contents" do
    trending = create(:trending)
    media_container = create(:media_container)
    products_container = create(:products_container)

    form = double(
      valid?: true,
      trending_contents: [
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
      Panel::UpdateTrendingService.new(trending, form).call
    }.to change(TrendingContent, :count).by(2)
  end

  it "remove old trending contents" do
    trending = create(:trending)
    media_container = create(:media_container)
    products_container = create(:products_container)
    products_container2 = create(:products_container)
    create(:trending_content, trending: trending, content: media_container)
    create(:trending_content, trending: trending, content: products_container)

    form = double(
      valid?: true,
      trending_contents: [
        OpenStruct.new(
          content_id: media_container.id,
          content_type: "MediaContainer"
        ),
        OpenStruct.new(
          content_id: products_container2.id,
          content_type: "ProductsContainer"
      )]
    )

    Panel::UpdateTrendingService.new(trending, form).call
    expect(
      TrendingContent.where(trending: trending, content: media_container).any?
    ).to be true
    expect(
      TrendingContent.where(trending: trending, content: products_container).any?
    ).to be false
    expect(
      TrendingContent.where(trending: trending, content: products_container2).any?
    ).to be true
  end
end
