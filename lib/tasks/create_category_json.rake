task create_category_json: :environment do
  xlsx_file = File.open('promptcloud_categories.xlsx')

  ParsePromptcloudCategoriesXlsx.new(xlsx_file).call
end
