class AddLikeCommentToBenchmarks < ActiveRecord::Migration
  def change
    add_column :execution_benchmarks, :like, :boolean
    add_column :execution_benchmarks, :user_comment, :string

    add_index :execution_benchmarks, [:like, :created_at], order: {:create_at => :desc}
  end
end
