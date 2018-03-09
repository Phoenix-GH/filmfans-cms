class AddImageToExecutionBenchmarks < ActiveRecord::Migration
  def change
    add_column :execution_benchmarks, :image, :string
  end
end
