require Rails.root.join('app', 'tasks', 'create_categories.rb')

class CreateCategoriesTaskRun < ActiveRecord::Migration
  def up
    Rake::Task['create_categories'].invoke
  end
end
