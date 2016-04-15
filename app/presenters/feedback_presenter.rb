class FeedbackPresenter < BasePresenter
  presents :feedback

  delegate :notes, :rating, :updated_at, :feedbackable, :technical_rating, :style_rating, :student, :teacher, to: :feedback

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

  def teacher_image
    if feedback.teacher
      image_tag(avatar_for(feedback.teacher), size: '75x75', class: 'teacher-avatar')
    end
  end

  def student_full_name
    if feedback.student.present?
      feedback.student.first_name + " " + feedback.student.last_name
    else
      'N/A'
    end
  end

  def date
    feedback.created_at.to_date.to_s
  end

  def time
    feedback.updated_at.strftime(" at %I:%M%p")
  end

  def reason
    if feedback.feedbackable.is_a? Assistance
      feedback.feedbackable.assistance_request.reason ? feedback.feedbackable.assistance_request.reason : "N/A"
    end
  end

end
