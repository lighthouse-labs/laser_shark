class TeacherFeedbackStatsSerializer < ActiveModel::Serializer

  root false

  attributes :direct, :lecture, :mentor

  def direct
    {
      average: teacher_direct_feedbacks.average_rating,
      total: teacher_direct_feedbacks.count
    }
  end

  def lecture
    {
      average: teacher_lecture_feedbacks.average_rating,
      total: teacher_lecture_feedbacks.count,
      teacher: group_by_date(teacher_lecture_feedbacks),
      everyone: group_by_date(all_lecture_feedbacks)
    }
  end

  def mentor
    {
      average: teacher_mentor_feedbacks.assistance.average_rating,
      total: teacher_mentor_feedbacks.assistance.count,
      teacher: group_by_date(teacher_mentor_feedbacks),
      everyone: group_by_date(all_mentor_feedbacks)
    }
  end

  protected

  def teacher_feedbacks
    object.feedbacks.completed
  end

  def teacher_lecture_feedbacks
    teacher_feedbacks.lecture
  end

  def teacher_mentor_feedbacks
    teacher_feedbacks.assistance
  end

  def teacher_direct_feedbacks
    teacher_feedbacks.direct
  end

  def all_feedbacks
    Feedback.teacher_feedbacks.completed
  end

  def all_lecture_feedbacks
    all_feedbacks.lecture
  end

  def all_mentor_feedbacks
    all_feedbacks.assistance
  end

  def group_by_date(feedback_collection)
    feedback_collection.group('1').order('1').pluck("feedbacks.created_at::date, ROUND(AVG(rating::numeric), 2)::float")
  end

end