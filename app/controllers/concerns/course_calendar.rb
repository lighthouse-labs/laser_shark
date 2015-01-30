module CourseCalendar
  extend ActiveSupport::Concern

  included do
    helper_method :today
    helper_method :today?
    helper_method :previous_day?
    helper_method :day
    helper_method :weekend?
    before_filter :allowed_day?
  end

  private

  def weekend?
    !!(day =~ /(?<=w\d)e$/)
  end

  def day
    return @day if @day
    d = params[:number] || params[:day_number]
    @day = case d
    when nil, 'today'
      today
    when 'yesterday'
      yesterday
    else
      d
    end
    @day = CurriculumDay.new(@day, cohort) if @day.is_a?(String)
    @day
  end

  def today
    @today ||= CurriculumDay.new(Date.current, cohort)
  end

  def today?
    day == today
  end

  def previous_day?
    day.to_s < today.to_s
  end

  def yesterday
    @yesterday ||= CurriculumDay.new(Date.current.yesterday, cohort)
  end

  def allowed_day?
    # return true if day == 'setup' # setup always allowed, for now - KV
    unless current_user.can_access_day?(day)
      if today?
        redirect_to(setup_path, alert: 'Access not allowed yet.')
      else
        redirect_to(day_path('today'), alert: 'Access not allowed yet.')
      end
    end
  end

end
