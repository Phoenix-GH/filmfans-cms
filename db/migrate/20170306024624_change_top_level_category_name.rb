class ChangeTopLevelCategoryName < ActiveRecord::Migration
  def change
    Category.find(Category::WOMAN_CATEGORY_ID).update_attributes({name: 'Women\'s fashion'})
    Category.find(Category::MAN_CATEGORY_ID).update_attributes({name: 'Men\'s fashion'})
  end
end
