describe ParsePromptcloudCategoriesXlsx do
  before do
    @xlsx =
      File.open("#{Rails.root}/spec/fixtures/files/products_categories.xlsx")

    @expected_json =
      File.read("#{Rails.root}/spec/fixtures/files/products_categories.json")
  end

  it 'adds new categories json file' do
    ParsePromptcloudCategoriesXlsx.new(@xlsx).call
    json_file = File.read("#{Rails.root}/spec/support/promptcloud_categories.json")
    expect(json_file).to eq @expected_json
  end
end
