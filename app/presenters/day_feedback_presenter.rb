class DayFeedbackPresenter < BasePresenter
  presents :dayfeedback
  def capitalized_day
    dayfeedback.day.upcase
  end

  def row_class
    "#{dayfeedback.mood}-row " + "#{dayfeedback.try(:student).try(:cohort).try(:active?)}-row"
  end

  def location_name
    dayfeedback.try(:student).try(:location).try(:name) || 'N/A'
  end

  def student_name
    dayfeedback.try(:student).try(:full_name) || 'N/A'
  end

  def created_at_with_time
    dayfeedback.created_at
  end

  def text
    dayfeedback.text
  end

  def archived_at
    dayfeedback.archived_at
  end
end