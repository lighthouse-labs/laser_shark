class FeedbackPresenter < BasePresenter
  presents :feedback

  delegate :updated_at, :feedbackable, :technical_rating, :style_rating, :student, :teacher, to: :feedback

  def truncated_notes
    if feedback.notes.present? 
      truncate feedback.notes, length: 200
    end
  end

  def upcased_day
    if feedback.try(:feedbackable)
      feedback.feedbackable.day.upcase
    elsif feedback.student.present?
      CurriculumDay.new(feedback.created_at.to_date, feedback.student.cohort).to_s.upcase
    else
      # If the student is no longer registered for some reason, display just the date
      feedback.created_at.to_date.to_s
    end
  end

  def feedbackable_name
    if feedback.try(:feedbackable) && feedback.feedbackable.try(:name)
      feedback.feedbackable.name
    elsif feedback.try(:feedbackable)
      'N/A'
    else
      ''
    end
  end

  def feedbackable_type
    if feedback.try(:feedbackable) && feedback.feedbackable.try(:type)
      feedback.feedbackable.type
    elsif feedback.try(:feedbackable)
      feedback.feedbackable.class.name
    else
      'Direct Feedback'
    end
  end

  def teacher_full_name
    if feedback.teacher.present?
      feedback.teacher.first_name + " " + feedback.teacher.last_name
    else
      'N/A'
    end
  end

  def student_full_name
    if feedback.student.present?
      feedback.student.first_name + " " + feedback.student.last_name
    else
      'N/A'
    end
  end

  def updated_date
    feedback.updated_at.to_date.to_s
  end

end