module CourseCalendar
  extend ActiveSupport::Concern

  included do
    helper_method :today
    helper_method :day
    before_filter :allowed_day?
  end

  private

  def day
    @week_day_number = params[:number]
    return today if !day?
    return today if @week_day_number == 'today'
    return yesterday if @week_day_number == 'yesterday'
    return "w8d5" if end_of_bootcamp?
    return @week_day_number if !end_of_bootcamp?
  end

  def day?
    @week_day_number.nil?
  end

  def end_of_bootcamp?
    week_number < 8 || (week_number == 8 && day_number <= 5)
  end

  def week_number
    params[:number].split("d")[0].split("w")[1].to_i
  end

  def day_number
    params[:number].split("d")[1].to_i
  end

  def today
    @today ||= CurriculumDay.new(Time.zone.now.to_date, cohort).to_s
  end

  def yesterday
    @yesterday ||= CurriculumDay.new((Time.zone.now.to_date - 1).to_date, cohort).to_s
  end

  def allowed_day?
    # raise day.inspect
    redirect_to(day_path('today'), alert: 'Access not allowed yet!') unless current_user.can_access_day?(day)
  end

end
