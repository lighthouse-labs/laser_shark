module CourseCalendar
  extend ActiveSupport::Concern

  included do
    helper_method :today
    helper_method :day
    before_filter :allowed_day?
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
      
      week_day_string = params[:number].split("d")
      week = week_day_string[0].split("w")[1].to_i
      day = week_day_string[1].to_i

      if (week < 8) || (week == 8 && day <= 5)
        d
      else 
        d = "w8d5"
        redirect_to day_path(d)
      end

    end
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
