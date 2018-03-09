describe Panel::Wizards::CreateProductCategoryService do
  it "create new relations" do
    product1 = create(:product)
    category = create(:category)
    category2 = create(:category)
    expect{
      Panel::Wizards::CreateProductCategoryService.new(product1, [category.id, category2.id]).call
    }.to change(ProductCategory, :count).by(2)
  end

  it "remove old relations" do
    product1 = create(:product)
    category = create(:category)
    category2 = create(:category)
    category3 = create(:category)
    create(:product_category, product: product1, category: category)
    create(:product_category, product: product1, category: category2)

    Panel::Wizards::CreateProductCategoryService.new(product1, [category3.id]).call
    expect(
      ProductCategory.where(product: product1, category: category).any?
    ).to be false
    expect(
      ProductCategory.where(product: product1, category: category3).any?
    ).to be true
  end
end
