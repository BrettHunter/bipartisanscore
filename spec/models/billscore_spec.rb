require 'rails_helper'

describe Billscore do
  
  before do
    FactoryGirl.create(:billscore)  
    FactoryGirl.create(:billscore_vote)
    FactoryGirl.create(:legislator)
  end
  
  describe "#get_last_vote_update_time" do
    it "should return a Time object representing the last vote update" do
      object = Billscore.get_last_vote_update_time
      expect(object).to be_kind_of(Time)
    end
  end
  
  describe "#get_last_billscore_update_time" do
    it "should return a Time object representing the last Billscore update" do
      object = Billscore.get_last_billscore_update_time
      expect(object).to be_kind_of(Time)
    end
  end
  
  describe "#calculate_yea_nay" do
    it "should return the number of yea votes and number of nay votes for roll_id" do
      roll_id = "0-2014"
      expected_array = [1,1]
      object = Billscore.calculate_yea_nay(roll_id)
      expect(object).to match_array(expected_array) 
    end
  end
  
  describe "#calculate_dyes" do
    it "should return the number of yea votes made by democrats for a given roll_id" do
      roll_id = "0-2014"
      expected = 1
      object = Billscore.calculate_dyes(roll_id)
      expect(object).to eq(expected) 
    end
  end
  
end  
  