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
    @today ||= CurriculumDay.new(Time.zone.now.to_date, cohort).to_s
  end

  def today?
    day == today
  end

  def previous_day?
    day < today
  end

  def yesterday
    @yesterday ||= CurriculumDay.new((Time.zone.now.to_date - 1).to_date, cohort).to_s
  end

  def allowed_day?
    # return true if day == 'setup' # setup always allowed, for now - KV
    unless current_user.can_access_day?(day)
      redirect_to(setup_path, alert: 'Access not allowed yet.')
    end
  end

end
