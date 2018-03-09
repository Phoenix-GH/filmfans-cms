class CreateExecutionBenchmarks < ActiveRecord::Migration
  def change
    create_table :execution_benchmarks do |t|
      t.text :benchmark_key, null: false, index: true
      t.integer :execution_ms, null: false
      t.integer :breakdown_1_ms, null: true
      t.integer :breakdown_2_ms, null: true
      t.integer :breakdown_3_ms, null: true
      t.integer :breakdown_4_ms, null: true
      t.jsonb :details, null: false, default: '{}'
      t.timestamps null: false
    end
  end
end
