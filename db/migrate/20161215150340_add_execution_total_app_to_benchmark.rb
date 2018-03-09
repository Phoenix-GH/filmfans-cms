class AddExecutionTotalAppToBenchmark < ActiveRecord::Migration
  def change
    add_column :execution_benchmarks, :total_time_from_app, :integer
    add_column :benchmark_multi_object_crops, :total_time_from_app, :integer
  end
end
