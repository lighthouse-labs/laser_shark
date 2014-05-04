class DaysController < ApplicationController

  def show
    @activities = Activity.chronological.for_day(day)
  end

  private

  def day
    @day ||= case params[:day]
    when nil, 'today'
      today
    when 'yesterday'
      yesterday
    else
      params[:day]
    end
  end
  helper_method :day

  def today
    @today ||= formatted_day_for(Date.today)
  end
  helper_method :today

  def yesterday
    @yesterday ||= formatted_day_for(Date.today - 1)
  end

  def formatted_day_for(date)
    days = (date.to_date - cohort.start_date).to_i
    w = (days / 7) + 1
    if date.sunday? || date.saturday?
      "w#{w}e"
    else
      "w#{w}d#{date.wday}"
    end
  end

end
