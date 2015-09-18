class ActivitySubmissionsController < ApplicationController

  include CourseCalendar # concern

  before_filter :retrieve_activity

  def create
    @activity_submission = @activity.activity_submissions.new(
      user: current_user,
      github_url: params[:github_url]
      )

    if @activity_submission.save
      if @activity.allow_submissions?
        @feedback = Feedback.create(student_id: current_user.id)
        @feedback.feedbackable = @activity
        @feedback.save
      end
      redirect_to :back
    else
      redirect_to :back, alert: "Error: #{@activity_submission.errors.full_messages[0]}"
    end
  end

  def destroy
    feedback = @activity.feedbacks.find_by_student_id(current_user.id)
    feedback.destroy if feedback
    activity_submission = @activity.activity_submissions.find_by(user: current_user)
    activity_submission.destroy if activity_submission

    redirect_to :back
  end

  private
  def retrieve_activity
    @activity = Activity.find(params[:activity_id])
  end
end
