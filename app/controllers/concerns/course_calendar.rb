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
      d
    end
  end

  def today
    @today ||= CurriculumDay.new(Date.today, cohort).to_s
  end

  def yesterday
    @yesterday ||= CurriculumDay.new((Date.today - 1).to_date, cohort).to_s
  end

  def allowed_day?
    # raise day.inspect
    redirect_to(day_path('today'), alert: 'Access not allowed yet!') unless current_user.can_access_day?(day)
  end

end
