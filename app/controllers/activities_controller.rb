class ActivitiesController < ApplicationController

  include CourseCalendar # concern

  before_action :require_teacher, only: :update

  def show
    @activity = Activity.chronological.for_day(day).find(params[:id])
    @next_activity = @activity.next
    @previous_activity = @activity.previous
  end

  def update
    activity = Activity.for_day(day).find(params[:id])

    if params[:update_gist]
      if params[:update_gist] == "instructions"
        activity.update_instructions_from_gist
      elsif params[:update_gist] == "teacher_notes"
        activity.update_teacher_notes_from_gist
      else
        render text: "Invalid update_gist parameter.", status: 500; return
      end
      redirect_to day_activity_url(activity.day, activity)
    end
  end

end
