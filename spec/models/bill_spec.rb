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
    it "should create mew Bill record" do       
      object = Bill.get_bill_from_api(1)      
      expect{Bill.create_bill(object)}.to change(Bill, :count).by(1)
    end   
  end
  
end
