class AddPostIdToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :post, index: true
  end
end
