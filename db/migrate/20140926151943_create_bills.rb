class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.string :bill_id
      t.string :chamber
      t.string :congress
      t.string :last_action_at
      t.string :official_title
      t.string :popular_title
      t.string :short_title
      t.string :sponsor_id
      t.string :urls
      t.string :summary
      t.string :summary_short
      t.string :cosponsor_ids

      t.timestamps
    end
  end
end
