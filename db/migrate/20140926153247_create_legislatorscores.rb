class CreateLegislatorscores < ActiveRecord::Migration
  def change
    create_table :legislatorscores do |t|
      t.string :bioguide_id
      t.integer :legislator_id
      t.integer :mocvts
      t.integer :mocpts
      t.decimal :mocscore
      t.string :chamberparty
      t.integer :bipartisanscore
      t.integer :globalscore
      t.text :each_vote_points

      t.timestamps
    end
  end
end
