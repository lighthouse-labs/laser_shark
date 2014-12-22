class PrepController < ApplicationController

  include CourseCalendar # concern

  skip_before_action :allowed_day?

  def show
    @activities = Activity.chronological.for_day("prep")
  end

end
