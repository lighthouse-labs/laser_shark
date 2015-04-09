module DaysHelper

  def setup?
    @setup
  end

  def day_status_css(d)
    classes = []
    classes.push('disabled') unless current_user.can_access_day?(d)

    d = CurriculumDay.new(d, cohort)

    classes.push('active') if d.to_s == day.to_s
    classes.push('today') if d.today?
    classes.push('unlocked') if d.unlocked?
    classes
  end

  def feedback_submitted?(day)
    student? && current_user.day_feedbacks.find_by(day: day.to_s)
  end
end
