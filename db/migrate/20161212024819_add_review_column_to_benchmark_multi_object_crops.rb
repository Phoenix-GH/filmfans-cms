class AddReviewColumnToBenchmarkMultiObjectCrops < ActiveRecord::Migration
  def change
    add_column :benchmark_multi_object_crops, :review, :string, index: true
    add_column :benchmark_multi_object_crops, :predicted_category, :string
    add_column :benchmark_multi_object_crops, :retrained_category, :string
    add_column :benchmark_multi_object_crops, :comment, :text
  end
end
