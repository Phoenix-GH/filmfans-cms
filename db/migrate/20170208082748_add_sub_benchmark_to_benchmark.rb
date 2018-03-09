class AddSubBenchmarkToBenchmark < ActiveRecord::Migration
  def change
    add_column :execution_benchmarks, :sub_benchmark_id, :integer, null: true, index: true
    add_column :execution_benchmarks, :main, :boolean, null: false, index: true, default: true
    add_column :execution_benchmarks, :judge_user, :string, null: true, index: true
    add_column :execution_benchmarks, :judgement, :string, null: true, index: true

    add_foreign_key :execution_benchmarks, :execution_benchmarks, column: :sub_benchmark_id, on_delete: :nullify
  end
end
