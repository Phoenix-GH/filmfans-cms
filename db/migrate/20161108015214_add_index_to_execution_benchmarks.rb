class AddIndexToExecutionBenchmarks < ActiveRecord::Migration
  def change
    add_index :execution_benchmarks, [:image, :review, :created_at]
  end
end
