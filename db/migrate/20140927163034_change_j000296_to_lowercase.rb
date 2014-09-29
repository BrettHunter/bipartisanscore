class ChangeJ000296ToLowercase < ActiveRecord::Migration
  def change
    rename_column :votes, :J000296, :j000296
  end
end
