class CreateLegislators < ActiveRecord::Migration
  def change
    create_table :legislators do |t|
      t.string :bioguide_id
      t.string :title
      t.string :first_name
      t.string :last_name
      t.string :party
      t.string :state
      t.string :chamber
      t.string :in_office
      t.string :gender
      t.string :website
      t.string :term_start
      t.string :term_end

      t.timestamps
    end
  end
end
