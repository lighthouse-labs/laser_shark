module DaysHelper

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

  def total_cohort_students
    @total_cohort_students ||= cohort.students.count
  end

  def completed_students(activity)
    completed_students = cohort.students.completed_activity(activity).count
    "#{completed_students}/#{total_cohort_students}"
  end
end
