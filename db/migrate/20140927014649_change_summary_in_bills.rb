class ChangeSummaryInBills < ActiveRecord::Migration
  def change
    change_column :bills, :summary, :text
    change_column :bills, :summary_short, :text
    change_column :bills, :official_title, :text
    change_column :bills, :short_title, :text
    change_column :bills, :popular_title, :text    
  end
end
