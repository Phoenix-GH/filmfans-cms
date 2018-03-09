describe CreateCategories do
  it 'creates products categories' do
    CreateCategories.new.call

    expect(Category.count).to eq(41)

    category_woman = Category.find_by(name: 'Woman')
    category_man = Category.find_by(name: 'Man')
    expect(category_woman.parent_id).to be_nil
    expect(category_man.parent_id).to be_nil
    expect(Category.find_by(name: 'Dresses').parent_id).to eq(category_woman.id)
    expect(Category.find_by(name: 'Shirts').parent_id).to eq(category_man.id)
  end
end
