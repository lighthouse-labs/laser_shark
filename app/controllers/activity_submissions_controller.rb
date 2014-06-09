class ActivitySubmissionsController < ApplicationController

  include CourseCalendar # concern

  before_filter :retrieve_activity

  def create
    @activity.activity_submissions.create(
      user: current_user
      )
    redirect_to :back
  end

  def destroy
    activity_submission = @activity.activity_submissions.find_by(user: current_user)
    activity_submission.destroy if activity_submission

    redirect_to :back
  end

  private
  def retrieve_activity
    @activity = Activity.find(params[:activity_id])
  end
end
