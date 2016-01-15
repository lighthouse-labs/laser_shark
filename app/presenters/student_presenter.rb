class StudentPresenter < UserPresenter
  
  presents :student

  delegate :mentor, :cohort, :l_score, to: :student

  def mentor_full_name
    if student.mentor.present?
      link_to student.mentor.full_name, teacher_path(student.mentor_id)
    else
      'No mentor assigned'
    end
  end

end