class CreateBenchmarkMultiObjectCrops < ActiveRecord::Migration
  def change
    create_table :benchmark_multi_object_crops do |t|
      t.jsonb :details, null: false, default: '{}'
      t.string :image
      t.references :execution_benchmark, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
