describe CategoryQuery do
  context 'order' do
    it 'by name alphabetically' do
      create(:category, name: 'First')
      create(:category, name: 'Second')

      results = CategoryQuery.new.results
      expect(results.map(&:name)).to eq(['First', 'Second'])
    end
  end

  context 'filters' do
    it 'parent_filter default show highest in hierarchy' do
      woman_category = create(:category, name: 'Woman')
      man_category = create(:category, name: 'Man')
      create(:category, name: 'Women shoes', parent_id: woman_category.id)
      create(:category, name: 'Men shoes', parent_id: man_category.id)

      results = CategoryQuery.new().results
      expect(results.map(&:name)).to eq(['Man', 'Woman'])
    end

    it 'parent_name_filter' do
      woman_category = create(:category, name: 'Woman')
      man_category = create(:category, name: 'Man')
      create(:category, name: 'Women shoes', parent_id: woman_category.id)
      create(:category, name: 'Men shoes', parent_id: man_category.id)

      results = CategoryQuery.new({ parent_name: 'Woman' }).results
      expect(results.map(&:name)).to eq(['Women shoes'])
    end

    it 'parent_id_filter' do
      woman_category = create(:category, name: 'Woman')
      create(:category, name: 'Women shoes', parent_id: woman_category.id)
      create(:category, name: 'Men shoes')

      results = CategoryQuery.new({ parent_id: woman_category.id }).results
      expect(results.map(&:name)).to eq(['Women shoes'])
    end
  end
end
