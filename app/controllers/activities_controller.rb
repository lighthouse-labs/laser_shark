class ActivitiesController < ApplicationController

  include CourseCalendar # concern

  def show
    @activity = Activity.chronological.for_day(day).find(params[:id])
    @next_activity = @activity.next
    @previous_activity = @activity.previous
  end

  def search
    @hide_side_search = true
    @activities = Activity.search(params[:query])
    @activities = @activities.select { |activity| current_user.can_access_day?(activity.day) }
  end

end
