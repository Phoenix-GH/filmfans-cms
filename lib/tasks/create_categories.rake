task create_categories: :environment do
  if CreateCategories.new.call
    puts "Complete!"
  end
end
