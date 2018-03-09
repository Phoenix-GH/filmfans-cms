class AddReviewAttributesToBenchmark < ActiveRecord::Migration
  def change
    add_column :execution_benchmarks, :review, :string, index: true
    add_column :execution_benchmarks, :predicted_category, :string
    add_column :execution_benchmarks, :retrained_category, :string
    add_column :execution_benchmarks, :comment, :text
  end
end
