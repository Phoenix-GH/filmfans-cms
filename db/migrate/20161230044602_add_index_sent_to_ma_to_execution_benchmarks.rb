class AddIndexSentToMaToExecutionBenchmarks < ActiveRecord::Migration
  def change
    add_index :execution_benchmarks, :sent_to_ma
  end
end
