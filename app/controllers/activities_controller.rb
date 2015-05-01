class ActivitiesController < ApplicationController

  include CourseCalendar # concern

  before_action :require_activity, only: [:show, :edit, :update]
  before_action :teacher_required, only: [:edit, :update]

  def new
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      redirect_to day_activity_path(@activity.day, @activity), notice: "#{@activity.name} has been created!"
    else
      render :new, notice: 'Sorry, something went wrong'
    end
  end

  def show
    @setup = day.to_s == 'setup'

    @next_activity = @activity.next
    @previous_activity = @activity.previous    
    @activity_submission = current_user.activity_submissions.where(activity: @activity).first || ActivitySubmission.new
    @next_activity = @activity.next
    @previous_activity = @activity.previous

    if teacher?
      @messages = @activity.messages
    else
      @messages = @activity.messages.for_cohort(cohort).where(for_students: true)
    end
  end

  def edit
  end

  def update
    if @activity.update(activity_params)
      redirect_to day_activity_path(@activity.day, @activity), notice: 'Updated!'
    else
      render :edit, notice: 'Sorry, something went wrong'
    end
  end

  private

  def activity_params
    params.require(:activity).permit(:name, :type, :duration, :start_time, :instructions, :teacher_notes, :allow_submissions, :day, :gist_url, :media_filename)
  end

  def teacher_required
    redirect_to(day_activity_path(@activity.day, @activity), alert: 'Not allowed') unless teacher?
  end

  def require_activity
    @activity = Activity.find(params[:id])
  end

end
