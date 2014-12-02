class DaysController < ApplicationController

  include CourseCalendar # concern

  def show
    @activities = Activity.active.chronological.for_day(day)
  end


end
