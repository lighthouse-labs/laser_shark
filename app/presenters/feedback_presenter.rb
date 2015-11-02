class FeedbackPresenter < BasePresenter
  presents :feedback

  def notes?
    feedback.notes.present?
  end

  def truncated_notes
    truncate feedback.notes, length: 200
  end

  def upcased_day
    if feedbackable_present?
      feedback.feedbackable.day.upcase
    else
      CurriculumDay.new(feedback.created_at.to_date, feedback.student.cohort).to_s.upcase
    end
  end

  def feedbackable_present?
    feedback.try(:feedbackable)
  end

  def feedbackable_name
    if feedbackable_present? && feedback.feedbackable.try(:name)
      feedback.feedbackable.name
    elsif feedbackable_present?
      'N/A'
    else
      ''
    end
  end

  def feedbackable_type
    if feedbackable_present? && feedback.feedbackable.try(:type)
      feedback.feedbackable.type
    elsif feedbackable_present?
      feedback.feedbackable.class.name
    else
      'Direct Feedback'
    end
  end

  def teacher?
    feedback.teacher.present?
  end

  def teacher_full_name
    if teacher?
      feedback.teacher.first_name + " " + feedback.teacher.last_name
    else
      'N/A'
    end
  end

  def student?
    feedback.student.present?
  end

  def student_full_name
    if student?
      feedback.student.first_name + " " + feedback.student.last_name
    else
      'N/A'
    end
  end

end