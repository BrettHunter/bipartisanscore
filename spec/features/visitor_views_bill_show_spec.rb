require "rails_helper"

feature "The Bill Show Page" do
  scenario "a visitor views the bill show page" do
    bill = FactoryGirl.create(:bill)
    visit bill_path(bill)
    expect(page).to have_content(bill.bill_id)
    
  end
end