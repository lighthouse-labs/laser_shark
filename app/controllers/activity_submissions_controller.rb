class ActivitySubmissionsController < ApplicationController

  include CourseCalendar # concern

  before_filter :retrieve_activity

  def create
    activity_params = activity_submission_params.dup
    activity_params["data"] = JSON.parse(activity_params["data"]) unless activity_params["data"].blank?
    @activity_submission = @activity.activity_submissions.new(activity_params)
    @activity_submission.user = current_user

    if @activity_submission.save
      respond_to do |format|
        format.html { redirect_to :back }
        format.js { render json: @activity_submission, root: false }
      end
    else
      redirect_to :back, alert: "Error: #{@activity_submission.errors.full_messages[0]}"
    end
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

  def activity_submission_params
    params.require(:activity_submission).permit(:github_url, :data)
  end

end
