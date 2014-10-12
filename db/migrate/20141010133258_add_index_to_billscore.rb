class AddIndexToBillscore < ActiveRecord::Migration
  def change
    add_index :billscores, :chamber
    add_index :votes, :pertinent_vote
    add_index :votes, :chamber    
  end
end
