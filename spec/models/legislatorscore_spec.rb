require 'rails_helper'

describe Legislatorscore do
 
  before do
    FactoryGirl.create(:legislatorscore)
    FactoryGirl.create(:legislator, bioguide_id: "j000296", party: "D")
    FactoryGirl.create(:legislator, bioguide_id: "c001102", party: "D")
    FactoryGirl.create(:legislator, bioguide_id: "c001101", party: "D")
    FactoryGirl.create(:legislator, bioguide_id: "b001288", party: "D")
    FactoryGirl.create(:legislator, bioguide_id: "s001195", party: "R")
    FactoryGirl.create(:legislator, bioguide_id: "w000818", party: "R")
    FactoryGirl.create(:legislator, bioguide_id: "m001192", party: "R")
    FactoryGirl.create(:legislator, bioguide_id: "b001289", party: "R")     
    FactoryGirl.create(:billscore, bill_id: "hr999-113", chamber: "house", roll_id: "1-2014", pscore: 80, combined_pscore: "120")
    FactoryGirl.create(:billscore, bill_id: "hr999-113", chamber: "senate", roll_id: "2-2014", pscore: 40, combined_pscore: "120")
    FactoryGirl.create(:billscore, bill_id: "hr998-113", chamber: "house", roll_id: "3-2014", pscore: 75, combined_pscore: "75")
    FactoryGirl.create(:billscore, bill_id: "hr997-113", chamber: "house", roll_id: "4-2014", pscore: 88, combined_pscore: "88")
    FactoryGirl.create(:billscore, bill_id: "s999-113", chamber: "senate", roll_id: "s1-2014", pscore: 25, combined_pscore: "120")
    FactoryGirl.create(:billscore, bill_id: "s999-113", chamber: "house", roll_id: "5-2014", pscore: 95, combined_pscore: "120")
    FactoryGirl.create(:billscore, bill_id: "s998-113", chamber: "senate", roll_id: "s2-2014", pscore: 85, combined_pscore: "85")
    FactoryGirl.create(:vote, j000296: "Yea", c001102: nil, c001101: "Nay", b001288: "Yea", 
      s001195: "Nay", w000818: "Nay", m001192: "Yea", b001289: nil, roll_id: "0-2014", result: "Passed", 
      chamber: "house", pertinent_vote: "false")
    FactoryGirl.create(:vote, j000296: "Yea", c001102: "Yea", c001101: "Nay", b001288: "Yea", 
      s001195: "Nay", w000818: "Nay", m001192: "Yea", b001289: nil, roll_id: "1-2014", result: "Passed",
      chamber: "house", pertinent_vote: "true")
    FactoryGirl.create(:vote, j000296: "Yea", c001102: "Nay", c001101: "Nay", b001288: "Yea", 
      s001195: "Nay", w000818: "Nay", m001192: "Yea", b001289: nil, roll_id: "2-2014", result: "Passed", 
      chamber: "house", pertinent_vote: "true")
  end
  
  describe "#get_last_vote_update_time" do
    it "should return a Time object representing the last vote update" do
      
      object = Legislatorscore.get_last_vote_update_time
      expect(object).to be_kind_of(Time)
    end
  end  
  
  describe "#get_last_legislatorscore_update_time" do
    it "should return a Time object representing the last Legislatorscore update time" do
      
      object = Legislatorscore.get_last_legislatorscore_update_time
      expect(object).to be_kind_of(Time)
    end
  end  
  
  describe "#calculate_mocvts" do
    it "should return the number of Yea and Nay pertinent votes for a given legislator" do
      
      object = Legislatorscore.calculate_mocvts("c001102")
      expect(object).to eq(2)
    end
  end  
  
  describe "#calculate_chamber_votes" do
    it "should return the number of pertinent vote records for a given chamber" do
      
      object = Legislatorscore.calculate_chamber_votes("house")
      expect(object).to eq(2)
    end
  end 
  
  describe "#determine_vote_penalty" do
    it "should determine if a vote penalty should exist for a given legislator" do
      
      object = Legislatorscore.determine_vote_penalty("j000296")
      expect(object).to eq(false)
    end
  end 
  
  describe "#determine_voteresult" do
    it "should determine a voteresult from api language" do
      
      object = Legislatorscore.determine_voteresult("Passed")
      expect(object).to eq("Yea")
    end
  end 
  
end  