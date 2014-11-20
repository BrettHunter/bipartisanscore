class AddB001290ToVote < ActiveRecord::Migration
  def change
    add_column :votes, :b001290, :string
  end
end
