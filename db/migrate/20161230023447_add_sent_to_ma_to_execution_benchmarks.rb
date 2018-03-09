class AddSentToMaToExecutionBenchmarks < ActiveRecord::Migration
  def change
    add_column :execution_benchmarks, :sent_to_ma, :boolean, default: false
  end
end
