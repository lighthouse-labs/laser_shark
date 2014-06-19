require 'spec_helper'

describe ActivitiesController do
  logged_in_user

  it "should retrieve the correct activity" do
    cohort = FactoryGirl.create(:cohort)
    activity = FactoryGirl.create(:activity, :day => "w1d1")
    get :show, :id => activity.id, :day_number => "w1d1"
    # get :show, :id => activity.id  /activites/:id
    assigns(:activity).should eq(activity)
  end

  it "sets the @next_activity and @previous_activity" do
    activity1 = FactoryGirl.create(:activity, day: "w1d1", start_time: 900)
    activity2 = FactoryGirl.create(:activity, day: "w1d1", start_time: 1100)
    activity3 = FactoryGirl.create(:activity, day: "w1d1", start_time: 1500)

    get :show, id: activity1.id, day_number: "w1d1"
    assigns(:previous_activity).should eq(nil)
    assigns(:next_activity).should eq(activity2)

    get :show, id: activity2.id, day_number: "w1d1"
    assigns(:previous_activity).should eq(activity1)
    assigns(:next_activity).should eq(activity3)

    get :show, id: activity3.id, day_number: "w1d1"
    assigns(:previous_activity).should eq(activity2)
    assigns(:next_activity).should eq(nil)
  end
end
