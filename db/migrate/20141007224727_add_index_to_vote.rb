class AddIndexToVote < ActiveRecord::Migration
  def change
    add_index :votes, :bill_id
    add_index :votes, :roll_id
  end
end
