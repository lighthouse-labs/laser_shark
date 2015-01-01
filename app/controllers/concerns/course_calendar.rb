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
    @today ||= CurriculumDay.new(Time.zone.now.to_date, cohort).to_s
  end

  def yesterday
    @yesterday ||= CurriculumDay.new((Time.zone.now.to_date - 1).to_date, cohort).to_s
  end

  def allowed_day?
    # return true if day == 'prep' # prep always allowed, for now - KV
    unless current_user.can_access_day?(day)
      redirect_to(prep_path, alert: 'Access not allowed yet.')
    end
  end

end
