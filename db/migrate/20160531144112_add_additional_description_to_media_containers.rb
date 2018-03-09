class AddAdditionalDescriptionToMediaContainers < ActiveRecord::Migration
  def change
    add_column :media_containers, :additional_description, :text
  end
end
