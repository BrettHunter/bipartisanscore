require "rails_helper"

feature "The Legislators Index" do
  scenario "a visitor views the legislator index page" do
    legislator = FactoryGirl.create(:legislator)
    visit legislators_path
    expect(page).to have_content(legislator.first_name, legislator.last_name, legislator.state, legislator.title)
    
  end
end

