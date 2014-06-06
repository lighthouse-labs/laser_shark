class ActivitiesController < ApplicationController

  include CourseCalendar # concern

  def show
    @activity = Activity.chronological.for_day(day).find(params[:id])
    @next_activity = @activity.next
    @previous_activity = @activity.previous
  end

  def search
    @activities = Activity.search(params[:query])
  end

end
