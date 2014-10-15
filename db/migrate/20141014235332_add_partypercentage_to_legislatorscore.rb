class AddPartypercentageToLegislatorscore < ActiveRecord::Migration
  def change
    add_column :legislatorscores, :party_percentage, :integer
    add_column :legislatorscores, :yea_votes, :integer
    add_column :legislatorscores, :nay_votes, :integer
    add_column :legislatorscores, :bipartisan_yea_votes, :integer
    add_column :legislatorscores, :bipartisan_nay_votes, :integer
    add_column :legislatorscores, :bipartisan_votes, :integer
    add_column :legislatorscores, :effective_bipartisan_votes, :integer
    add_column :legislatorscores, :chamberparty_rank, :integer
    add_column :legislatorscores, :chamberparty_count, :integer
  end
end
