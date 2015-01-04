require "rails_helper"

feature "The Bill Index Page" do
  scenario "a visitor views the bill index page" do
    bill = FactoryGirl.create(:bill)
    visit bills_path
    expect(page).to have_content(bill.bill_id)
    
  end
end