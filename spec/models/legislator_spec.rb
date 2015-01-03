require 'rails_helper'

describe Legislator do
  
  before do
    FactoryGirl.create(:legislator)
    FactoryGirl.create(:legislatorscore, legislator_id: "1", chamberparty: "dem_house", bipartisanscore: "50", 
      bioguide_id: "j000296", mocscore: "2.8")
    FactoryGirl.create(:legislatorscore, legislator_id: "2", chamberparty: "dem_house", bipartisanscore: "50",
      bioguide_id: "c001102", mocscore: "3.3")
    FactoryGirl.create(:legislatorscore, legislator_id: "3", chamberparty: "rep_house", bipartisanscore: "50",
      bioguide_id: "c001101", mocscore: "3.8")
    FactoryGirl.create(:legislatorscore, legislator_id: "4", chamberparty: "dem_senate", bipartisanscore: "50",
      bioguide_id: "b001288", mocscore: "4.1")
    FactoryGirl.create(:legislatorscore, legislator_id: "5", chamberparty: "rep_senate", bipartisanscore: "50",
      bioguide_id: "s001195", mocscore: "4.9")
  end
  
  describe "#get_legislators" do
    it "should return legislator object with bioguide_id from the API" do
      object = Legislator.get_legislators(1)
      expect(object.results[0].bioguide_id).to be_kind_of(String)
    end
  end
  
  describe "#get_chamberparty" do
    it "should return the chamberparty of a legislator given a legislator id" do
      object = Legislator.get_chamberparty(1)
      expect(object).to eq('dem_house')
    end
  end
   
  describe "#chamberparty_count" do
    it "should return the number of legislators with a particular chamberparty" do
      object = Legislator.chamberparty_count("dem_house")
      expect(object).to eq(2)
    end
  end
  
  describe "#chamberparty_rank" do
    it "should return a legislator's rank within his or her chamberparty" do
      object = Legislator.chamberparty_rank("dem_house", 2.8)
      expect(object).to eq(2)
    end
  end
  
  describe "#chamberparty_descriptor" do
    it "should return the chamberparty descriptor for a legislator's chamberparty" do
      object = Legislator.chamberparty_descriptor("dem_house")
      expect(object).to eq('House Democrats')
    end
  end
  
  describe "#rank_tie_count" do
    it "should return the number of legislators with the same bipartisanscore within a particular chamberparty" do
      object = Legislator.rank_tie_count("dem_house", 50)
      expect(object).to eq(1)
    end
  end
  
end

      