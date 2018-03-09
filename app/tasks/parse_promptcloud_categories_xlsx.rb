class ParsePromptcloudCategoriesXlsx
  def initialize(xlsx_file)
    @data = RubyXL::Parser.parse(xlsx_file).worksheets[0]
    @json = {}
  end

  def call
    create_categories
    write_json_to_file
  end

  private
  def create_categories
    @data.each do |row|
      next if row_is_empty?(row) || category_to_be_removed?(row)

      category_id = row.cells[1].value.to_s.split(',')
      category_hierarchy = row.cells[4].value.split(' -> ').to_s

      @json[category_hierarchy] = category_id
    end
  end

  def write_json_to_file
    Dir.chdir(file_dir) do
      output = File.open('promptcloud_categories.json', 'w')
      output << @json.to_json
      output.write "\n"
      output.close
    end
  end

  def row_is_empty?(row)
    row.nil?
  end

  def category_to_be_removed?(row)
    row.cells[1].nil? ||
      row.cells[1].value.nil? || row.cells[2].value != 1
    # row.cells[1]: nil for categories that should not be imported
    # row.cells[2]: value 0 for categories not searched by promptcloud
  end

  def file_dir
    Rails.env.test? ? 'spec/support' : '.'
  end
end
