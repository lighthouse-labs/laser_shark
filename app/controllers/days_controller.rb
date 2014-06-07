class DaysController < ApplicationController

  include CourseCalendar # concern

  def show
    @activities = Activity.chronological.for_day(day)
  end

  protected

  def time_estimate start, finish
    result = finish - start

    if result <= 60
      result.to_s << " Min"
    else
      result = (((result / 60.00) *2).round / 2.0).to_s
      result.to_i > 1 ? result << " Hours" : result << " Hour"
    end
  end
  helper_method :time_estimate
end
