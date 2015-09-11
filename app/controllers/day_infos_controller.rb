class DayInfosController < ApplicationController

  include CourseCalendar # concern

  before_action :teacher_required
  before_action :load_day_info, only: [:edit, :update]

  def update
    if @day_info.update day_info_params
      redirect_to day_path(day.raw_date)
    else
      render :edit
    end
  end

  protected

  def teacher_required
    redirect_to(@day, alert: 'Not allowed') unless teacher?
  end

  def load_day_info
    @day_info = DayInfo.find_by(day: day.to_s)
  end
  
  def day_info_params
    params.require(:day_info).permit(:description)
  end

end