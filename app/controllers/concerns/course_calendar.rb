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
    if !day_accessible?
      today
    elsif day_accessible? || !end_of_bootcamp?
      @week_day
    else
      "w8d5"
    end
  end

  def day_accessible?
    (week_number <= today_week_number) && (day_number <= today_day_number)
  end


  def today_is_after_end_of_bootcamp?
    (today_week_number) > 8 || (today_week_number == 8 && today_day_number > 5)
  end

  def today_week_number
    today.split("d")[0].split("w")[1].to_i
  end

  def today_day_number
    today.split("d")[1].to_i
  end


  def end_of_bootcamp?
    (week_number) > 8 || (week_number == 8 && day_number > 5)
  end

  def week_number
    params[:number].split("d")[0].split("w")[1].to_i
  end

  def day_number
    params[:number].split("d")[1].to_i
  end


  def today
    @today ||= CurriculumDay.new(Time.zone.now.to_date, cohort).to_s
    # if !end_of_bootcamp?
      # @today ||= CurriculumDay.new(Time.zone.now.to_date, cohort).to_s
    # else
    #   @today = "w8d5"
    # end
  end

  def yesterday
    @yesterday ||= CurriculumDay.new((Time.zone.now.to_date - 1).to_date, cohort).to_s
  end

  def allowed_day?
    # raise day.inspect
    redirect_to(day_path('today'), alert: 'Access not allowed yet!') unless current_user.can_access_day?(day)
  end

end
