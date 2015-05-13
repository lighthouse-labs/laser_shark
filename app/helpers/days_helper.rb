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

  def total_cohort_students
    @total ||= cohort.students.length
  end

  def completed_students(activity)
    completed = User.count_by_sql("SELECT count(*) FROM users 
      JOIN activity_submissions on activity_submissions.user_id = users.id
      WHERE cohort_id = #{cohort.id} AND activity_submissions.activity_id = #{activity.id}")
    "#{completed}/#{total_cohort_students}"
  end
end
