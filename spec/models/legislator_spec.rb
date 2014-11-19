require 'rails_helper'

describe Legislator do
  
  before do
    FactoryGirl.create(:legislator)
  end
  
  describe "#get_legislators" do
    it "should return legislator object with bioguide_id from the API" do
      object = Legislator.get_legislators(1)
      expect(object.results[0].bioguide_id).to be_kind_of(String)
    end
  end
  
end

      