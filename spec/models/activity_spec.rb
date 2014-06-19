require 'spec_helper'

describe Activity do

  it "has a valid factory" do
    expect(build(:activity)).to be_valid
  end

  it "should be invalid without name" do
    activity = build(:activity, name: nil)
    expect(activity).to be_invalid
    expect(activity).to have(1).errors_on(:name)
  end

  it "should be invalid without day" do
    activity = build(:activity, day: nil)
    expect(activity).to be_invalid
    expect(activity).to have(1).errors_on(:day)
  end

  it "should calculate the end time of an activity" do
    activity = create(:activity, start_time: 900, duration: 90)
    activity.end_time.should eql 1030

    activity = create(:activity, start_time: 1100, duration: 30)
    activity.end_time.should eql 1130

    activity = create(:activity, start_time: 1130, duration: 30)
    activity.end_time.should eql 1200 

    activity = create(:activity, start_time: 1130, duration: 40)
    activity.end_time.should eql 1210 
  end

  describe "#search" do
    it "does not perform a search if the query is empty" do
      activities = Activity.search("")
      activities.should be_nil
    end

    it "returns blank if no matches for the given keyword were found" do
      activities = Activity.search("x1y2z3")
      activities.should be_blank
    end

    it "returns all activities where activity.name contains at least one of the keywords" do
      activity = create(:activity, name: "Git 101")
      activity = create(:activity, name: "Forgit it")
      activity = create(:activity, name: "Command Line Basics")
      Activity.search("git").length.should eql 2
      Activity.search("basic").length.should eql 1
    end
  end

  describe "#search" do
    it "only returns activities that the current user can access" do

    end



  end

end
