module CourseCalendar
  extend ActiveSupport::Concern

  included do
    helper_method :today
    helper_method :day
  end

  private

  def day
    d = params[:number] || params[:day_number]
    @day ||= case d
    when nil, 'today'
      today
    when 'yesterday'
      yesterday
    else
      d
    end
  end

  def today
    @today ||= formatted_day_for(Date.today)
  end

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
