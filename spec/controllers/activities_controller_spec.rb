require 'spec_helper'

describe ActivitiesController do
  describe "GET #show" do
    logged_in_user

    before :each do
      @activity = FactoryGirl.create(:activity, day: 'w1d1')
    end

    describe "students in the prep course" do
      it "should be redirected to the prep course" do
        User.any_instance.stub(:prepping?).and_return('true')
        get :show, day_number: 'w1d1', id: @activity.id
        response.should redirect_to(prep_path)
      end
    end

  end

  describe "PATCH #update" do
    describe "teachers" do
      before :each do
        login_as FactoryGirl.create(:teacher, uid: 'uid', token: 'token')
      end

      it "can update lecture notes" do
        lecture = FactoryGirl.create(:lecture, day: 'w1d1')
        Lecture.any_instance.should_receive(:update_teacher_notes_from_gist).and_return(true)
        patch 'update', update_gist: 'teacher_notes', day_number: 'w1d1', id: lecture.id
        response.should be_success
      end

      it "can update activity notes" do
        activity = FactoryGirl.create(:activity, day: 'w1d1')
        Activity.any_instance.should_receive(:update_instructions_from_gist)
        patch 'update', update_gist: 'instructions', day_number: 'w1d1', id: activity.id
        response.should be_success
      end
      
      it "will not allow invalid messages" do
        activity = FactoryGirl.create(:activity, day: 'w1d1')
        patch 'update', update_gist: 'doesnt_exist', day_number: 'w1d1', id: activity.id
        response.should be_error
      end
    end

    describe "students" do
      before :each do
        @lecture = FactoryGirl.create(:lecture, day: 'w1d1')
        login_as FactoryGirl.create(:student, uid: 'uid', token: 'token')
      end

      it "cannot update gists" do
        patch 'update', update_gist: 'instructions', day_number: 'w1d1', id: @lecture.id
        response.should be_redirect
      end
    end
  end
end
