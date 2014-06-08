module CourseCalendar
  extend ActiveSupport::Concern

  included do
    helper_method :today
    helper_method :day
    before_filter :allowed_day?
  end

  private

  def day
    @week_day = params[:number]
    @day ||= case @week_day
    when nil, 'today'
      today
    when 'yesterday'
      yesterday
    else
      date_accesibility_check
    end
  end

  def date_accesibility_check
    return "w#{TOTAL_WEEKS}d#{TOTAL_DAYS}" if end_of_bootcamp?
    return @week_day if day_accessible?
    return today if !day_accessible?
  end

  def end_of_bootcamp?
    (today_week_number) > TOTAL_WEEKS || (today_week_number == TOTAL_WEEKS && today_day_number > TOTAL_DAYS)
  end

  def today_week_number
    today.split("d")[0].split("w")[1].to_i
  end

  def today_day_number
    today_day_number = today.split("d")[1].to_i
    return today_day_number if today_day_number != 0
    return 6 if today_day_number == 0
  end

  def day_accessible?
    (week_number <= today_week_number) && (day_number <= today_day_number)
  end

  def week_number
    params[:number].split("d")[0].split("w")[1].to_i
  end

  def day_number
    day_number = params[:number].split("d")[1].to_i
    return day_number if day_number != 0
    return 6 if day_number == 0
  end

  def today
    @today ||= CurriculumDay.new(Time.zone.now.to_date, cohort).to_s
  end

  def yesterday
    @yesterday ||= CurriculumDay.new((Time.zone.now.to_date - 1).to_date, cohort).to_s
  end

  def allowed_day?
    redirect_to(day_path('today'), alert: 'Access not allowed yet!') unless current_user.can_access_day?(day)
  end

end
