class CreateBillscores < ActiveRecord::Migration
  def change
    create_table :billscores do |t|
      t.string :bill_id
      t.string :roll_id
      t.string :result
      t.string :dpos
      t.string :rpos
      t.integer :ddev
      t.integer :rdev
      t.integer :drdev
      t.integer :ddif
      t.integer :rdif
      t.integer :drdif
      t.integer :yea
      t.integer :nay
      t.integer :dyes
      t.integer :dno
      t.integer :ryes
      t.integer :rno
      t.string :drpos
      t.integer :pscore
      t.integer :combined_pscore
      t.string :chamber
      t.integer :chamber_rank
      t.integer :global_rank
      t.integer :bill_table_id

      t.timestamps
    end
  end
end
