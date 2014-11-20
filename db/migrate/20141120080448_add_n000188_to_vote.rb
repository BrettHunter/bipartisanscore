class AddN000188ToVote < ActiveRecord::Migration
  def change
    add_column :votes, :n000188, :string
  end
end
