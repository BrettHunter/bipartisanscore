class AddVotedatToBillscore < ActiveRecord::Migration
  def change
    add_column :billscores, :voted_at, :string
  end
end
