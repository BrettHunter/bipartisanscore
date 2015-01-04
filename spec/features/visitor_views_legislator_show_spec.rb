require "rails_helper"

feature "The Legislator Show Page" do
  scenario "a visitor views the legislator show page" do
    legislator = FactoryGirl.create(:legislator)
    visit legislator_path(legislator)
    expect(page).to have_content(legislator.first_name, legislator.last_name, legislator.state, legislator.title)
    
  end
end