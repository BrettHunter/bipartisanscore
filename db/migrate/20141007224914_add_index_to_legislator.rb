class AddIndexToLegislator < ActiveRecord::Migration
  def change
    add_index :legislators, :bioguide_id
    add_index :legislatorscores, :bioguide_id
    add_index :billscores, :bill_id
    add_index :billscores, :roll_id
  end
end
