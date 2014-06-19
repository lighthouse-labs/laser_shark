require 'spec_helper'

describe 'Activities' do

  context "with an existing registered user" do

    before :each do
      cohort = FactoryGirl.create :cohort
      FactoryGirl.create :user_for_auth, cohort: cohort
      visit github_session_path

      activity1 = FactoryGirl.create :activity_assignment, name: "Ruby Objects" , day: "w1d1", start_time: 900
      activity2 = FactoryGirl.create :activity_assignment, name: "Contact List v1" , day: "w1d1", start_time: 1100
      activity3 = FactoryGirl.create :activity_assignment, name: "Breakout", day: "w1d1", start_time: 1500

    end

    it "can review the activites in a day" do
      visit day_path(number: "w1d1")
      find("nav.calendar") # waits for page to load

      page.should have_css("h1", :text => "Schedule")
      find_link("Ruby Objects").click

      # /days/w1d1/activites/1
      find(".nav-buttons")
      page.should have_css("h1", :text => "Ruby Objects")
      find_link("Next").click

      # /days/w1d1/activites/2
      find(".nav-buttons")
      page.should have_css("h1", :text => "Contact List v1")
      find_link("Previous").click

      # /days/w1d1/activites/1
      find(".nav-buttons")
      page.should have_css("h1", :text => "Ruby Objects")
    end
  end

end