class AddCountryToBenchmark < ActiveRecord::Migration
  def change
    add_column :execution_benchmarks, :country_code, :string
    add_column :execution_benchmarks, :country_name, :string
    add_column :execution_benchmarks, :action_date, :date

    add_index :execution_benchmarks, [:country_code, :action_date]
  end
end
