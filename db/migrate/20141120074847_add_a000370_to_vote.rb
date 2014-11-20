class AddA000370ToVote < ActiveRecord::Migration
  def change
    add_column :votes, :a000370, :string
  end
end
