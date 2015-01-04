require "rails_helper"

feature "The Home Page" do
  scenario "a visitor views the home page" do
    visit root_path
    expect(page).to have_content("Top Rated Senators")
  end
end
