class PrepController < ApplicationController

  include CourseCalendar

  skip_before_action :allowed_day?

  def show
    @module_number = "prep#{params[:number]}"
    @activities = Activity.for_day(@module_number).chronological
  end

end