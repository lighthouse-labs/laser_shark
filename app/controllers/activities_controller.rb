class ActivitiesController < ApplicationController

  include CourseCalendar # concern

  before_action :require_activity, only: [:show, :edit, :update, :autocomplete]
  before_action :teacher_required, only: [:new, :create, :edit, :update]
  before_action :check_if_day_unlocked, only: [:show]
  before_action :load_activity_test, only: [:new, :edit]
  before_action :load_day_or_section, only: [:new, :edit, :update]

  def new
    @activity = Activity.new(day: params[:day_number])
    @activity.section = @section if @section
  end

  def create
    @activity = Activity.new(activity_params)
    if @activity.save(activity_params)
      handle_redirect("Activity Created!")
    else
      load_day_or_section
      render :new
    end
  end

  def show
    @setup = day.to_s == 'setup'

    @next_activity = @activity.next
    @previous_activity = @activity.previous    

    # => For prep always create a new submission
    if @activity.section
      @activity_submission = ActivitySubmission.new
      @last_submission = current_user.activity_submissions.where(activity: @activity).last
    else
      @activity_submission = current_user.activity_submissions.where(activity: @activity).first || ActivitySubmission.new
    end

    @next_activity = @activity.next
    @previous_activity = @activity.previous

    @feedback = @activity.feedbacks.find_by(student: current_user)

    if teacher?
      @messages = @activity.messages
    else
      @messages = @activity.messages.for_cohort(cohort).where(for_students: true)
    end
  end

  def update
    if @activity.update(activity_params)
      handle_redirect("Updated!")
    else
      render :edit
    end
  end

  def autocomplete
    @outcomes = (Outcome.search(params[:term]) - @activity.outcomes)
    render json: ActivityAutocompleteSerializer.new(outcomes: @outcomes).outcomes.as_json, root: false
  end

  private

  def activity_params
    params.require(:activity).permit(
      :name,
      :type,
      :duration,
      :start_time,
      :instructions,
      :teacher_notes,
      :allow_submissions,
      :allow_feedback,
      :day,
      :section_id,
      :gist_url,
      :media_filename,
      :code_review_percent,
      activity_test_attributes: [:id, :test, :activity_id]
    )
  end

  def teacher_required
    redirect_to(day_activity_path(@activity.day, @activity), alert: 'Not allowed') unless teacher?
  end

  def require_activity
    @activity = Activity.find(params[:id])
  end

  def check_if_day_unlocked
    if student?
      redirect_to day_path('today'), alert: 'Not allowed' unless @activity.day == params[:day_number]
    end
  end

  def load_activity_test
    if params[:id] && require_activity.try(:activity_test)
      @activity_test = require_activity.activity_test 
    else
      @activity_test = ActivityTest.new
    end
  end

  def load_day_or_section
    if params[:day_number]
      @parent = :day
    elsif slug = params[:prep_id]
      @parent = Prep.find_by(slug: slug)
      @section = @parent
    end
  end

  def handle_redirect(notice)
    if @activity.section
      redirect_to prep_activity_path(@activity.section, @activity), notice: notice
    else
      redirect_to day_activity_path(@activity.day, @activity), notice: notice
    end
  end
end

