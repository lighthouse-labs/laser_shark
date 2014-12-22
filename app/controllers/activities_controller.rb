class ActivitiesController < ApplicationController

  include CourseCalendar # concern

  before_action :require_activity
  before_action :teacher_required, only: [:edit, :update]

  def show
    @next_activity = @activity.next
    @previous_activity = @activity.previous    
    @activity_submission = current_user.activity_submissions.where(activity: @activity).first || ActivitySubmission.new
    @next_activity = @activity.next
    @previous_activity = @activity.previous
  end

  def edit

  end

  def update
    if @activity.update(activity_params)
      redirect_to day_activity_path(@activity.day, @activity), notice: 'Updated!'
    else
      render :edit
    end
  end

  private

  def activity_params
    params.require(:activity).permit(:name, :duration, :start_time, :instructions, :teacher_notes, :allow_submissions, :day, :gist_url)
  end

  def teacher_required
    redirect_to(day_activity_path(@day, @activity), alert: 'Not allowed') unless teacher?
  end

  def require_activity
    @activity = Activity.chronological.for_day(day).find(params[:id])
  end

end
