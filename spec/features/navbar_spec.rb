require 'spec_helper'

describe 'Navbar' do

  context "when the student is logged out" do
    before :all do
      visit root_url
      if  page.has_content?("Sign Out")
        click_link "Sign Out"
      end
    end
    
    it "has valid links in the navbar" do
      visit root_url
      find_link("Home").click
      page.should have_css("h1", :text => "Login")
      visit root_url
      find_link("Log In").click
      page.should have_css("h1", :text => "Login")
      visit root_url
      find_link("Sign Up").click
      page.should have_css("h1", :text => "Login")
    end
  end

  context "when the student is logged in" do
    

    before :all do
      visit root_url
      if  page.has_content?("Sign Out")
        click_link "Sign Out"
      end
      cohort = FactoryGirl.create :cohort
      FactoryGirl.create :user_for_auth, cohort_id: cohort
      visit github_session_path
    end

    it "has valid links in the navbar" do
      visit root_url
      find_link("Home").click
      page.should have_css("h1", :text => "Laser Shark")
      visit root_url
      find_link("Schedule").click
      page.should have_css("h1", :text => "Schedule")
      visit root_url
      find_link("Edit profile").click
      page.should have_css("h1", :text => "Edit Your Details")
    end

  end
end
