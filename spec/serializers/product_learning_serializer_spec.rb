describe ProductLearningSerializer do
  it 'return' do
    image1 = create(:variant_file, normal_version_url: "http://variant_image.jpg")
    image2 = create(:variant_file, normal_version_url: "http://variant_image2.jpg")
    image3 = create(:variant_file, normal_version_url: "http://variant2_image.jpg")
    product_image = create(:product_file, normal_version_url: "http://default_image.jpg")
    variant = create(:variant, :with_variant_store, variant_files: [image1, image2])
    variant2 = create(:variant, :with_variant_store, variant_files: [image3])
    parent_category = create(:category, name: "Woman")
    category = create(:category, name: 'shoes', parent_category: parent_category)
    product = create(
      :product,
      name: 'new product',
      categories: [category],
      variants: [variant, variant2],
      product_files: [product_image]
    )
    results = ProductLearningSerializer.new(product).results

    expect(results).to eq(
      {
        id: product.id,
        name: "new product",
        category_id: category.id,
        parent_category_id: parent_category.id,
        category_hierarchy: [],
        default_images: ["http://default_image.jpg"],
        asin: "B0012GLDCU",
        variants:  [
          { variant_images: ["http://variant_image.jpg", "http://variant_image2.jpg"] },
          { variant_images: ["http://variant2_image.jpg"] }
        ]
      }
    )
  end

  it 'missing values' do
    product = create(
      :product,
      name: nil,
      brand: nil,
      description: nil
    )
    results = ProductLearningSerializer.new(product).results
    expect(results).to eq(
      {
        id: product.id,
        name: "",
        category_id: nil,
        parent_category_id: nil,
        category_hierarchy: [],
        default_images: [],
        asin: nil,
        variants: []
      }
    )
  end
end
