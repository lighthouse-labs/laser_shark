require 'spec_helper'

describe 'Navbar' do

  context "when the student is logged out" do
    it "has valid links in the navbar" do
      visit root_url
      find_link("Home").click
      page.should have_css("h1", :text => "Welcome to Compass")

      visit root_url
      page.should have_link("Sign In")
      find_link("Sign In").click
      page.should have_css("h1", :text => "Login")
    end
  end

  context "when the student is logged in" do


    before :each do
      cohort = FactoryGirl.create :cohort
      FactoryGirl.create :user_for_auth, cohort: cohort
      visit github_session_path
    end

    it "has valid links in the navbar" do
      visit root_url

      page.should_not have_link("Sign In")

      find_link("Home").click
      page.should have_css("h1", :text => "Welcome to Compass")

      visit root_url
      find_link("Schedule").click
      page.should have_css("h1", :text => "Schedule")

      visit root_url
      find_link("Edit profile").click
      page.should have_css("h1", :text => "Edit Your Details")
    end

  end
end
