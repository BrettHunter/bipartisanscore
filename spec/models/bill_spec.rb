require 'rails_helper'

describe Bill do   
  
  before do
    FactoryGirl.create(:bill)
  end
  
  describe "#get_last_api_update" do    
    it "should return a String object from the API" do      
      object = Bill.get_last_api_update
      expect(object).to be_kind_of(String)
    end
  end
  
  describe "#get_last_db_update" do    
    it "should return a String object from the API" do       
      object = Bill.get_last_db_update
      expect(object).to be_kind_of(Time)
    end
  end
  
  describe "#get_bill_from_api" do    
    it "should return Bill object from API" do       
      object = Bill.get_bill_from_api(1)
      expect(object.results[0].bill_id).to be_kind_of(String)
    end
  end
  
  describe "#create_bill" do    
    it "should create new Bill record" do       
      object = Bill.get_bill_from_api(1)      
      expect{Bill.create_bill(object)}.to change(Bill, :count).by(1)
    end   
  end  
  
  describe "#bill_rank" do
    it "should return the bill's rank within chamber" do      
      bill = FactoryGirl.create(:bill, chamber: "house")
      id = bill.id
      5.times {FactoryGirl.create(:billscore, pscore: "50", chamber: "house")}
      #ensure excludes ranking from different chamber
      5.times {FactoryGirl.create(:billscore, pscore: "0", chamber: "senate")}
      FactoryGirl.create(:billscore, pscore: "5", chamber: "house", bill_table_id: "#{id}")
      expect{Bill.bill_rank(id).to eq([1,11])}
    end
  end
  
  describe "#combined_opposition_factor" do
    it "should return a Bill's combined opposition factor" do      
      bill = FactoryGirl.create(:bill, chamber: "house")
      id = bill.id
      FactoryGirl.create(:billscore, pscore: "5", chamber: "house", bill_table_id: "#{id}")
      FactoryGirl.create(:billscore, pscore: "5", chamber: "senate", bill_table_id: "#{id}")      
      expect{Bill.bill_rank(id).to eq(10)}
    end
  end
      
  
end
