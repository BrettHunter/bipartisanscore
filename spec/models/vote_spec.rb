require 'rails_helper'

describe Vote do
  
  before do
    FactoryGirl.create_list(:vote, 100)
  end
  
  describe "#get_api_vote_count" do
    it "should retrieve the total number of votes from the API" do
      object = Vote.get_api_vote_count
      expect(object).to be_kind_of(Integer)
    end
  end
  
  describe "#get_db_vote_count" do
    it "should retrieve the total number of votes from the DB" do
      object = Vote.get_db_vote_count
      expect(object).to be_kind_of(Integer)
    end
  end
  
  describe "#get_vote" do
    it "should retrieve vote record with roll_id from the API" do
      object = Vote.get_vote(1)
      expect(object.roll_id).to be_kind_of(String)
    end
  end
  
  
end

    
   