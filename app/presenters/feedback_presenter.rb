class FeedbackPresenter < BasePresenter
  presents :feedback

  def notes?
    feedback.notes.present?
  end

  def truncated_notes
    truncate feedback.notes, length: 200
  end

  def upcased_day
    feedback.feedbackable.day.upcase
  end

  def feedbackable_present?
    feedback.try(:feedbackable)
  end

  def feedbackable_name
    if feedbackable_present? && feedback.feedbackable.try(:name)
      feedback.feedbackable.name
    else 
      'N/A'
    end
  end

  def feedbackable_type
    if feedbackable_present? && feedback.feedbackable.try(:type)
      feedback.feedbackable.type
    elsif feedbackable_present?
      feedback.feedbackable.class.name
    else
      'N/A'
    end
  end

  def teacher_full_name
    if feedback.teacher.present?
      feedback.teacher.first_name + " " + feedback.teacher.last_name
    else
      'N/A'
    end
  end

end