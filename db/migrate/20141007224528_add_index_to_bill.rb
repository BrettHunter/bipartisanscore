class AddIndexToBill < ActiveRecord::Migration
  def change
    add_index :bills, :bill_id
  end
end
