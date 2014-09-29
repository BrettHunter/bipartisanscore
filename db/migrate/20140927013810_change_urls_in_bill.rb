class ChangeUrlsInBill < ActiveRecord::Migration
  def change
    change_column :bills, :urls, :text
    change_column :bills, :cosponsor_ids, :text
  end
end
