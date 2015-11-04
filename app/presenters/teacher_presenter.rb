class TeacherPresenter < UserPresenter
  presents :teacher

  def company_info
    if teacher.company_name.present? && teacher.company_url.present?
      content_tag(:dt, "Company") + content_tag(:dd, company_link)
    end
  end
  
  def feedback_button
    if student?
      link_to "Feedback", '#', id: "teacher_feedback_button", class: 'btn btn-primary', data: {toggle: 'modal', target: '#teacher_feedback_modal', teacher_id: teacher.id}
    end
  end

  protected

  def company_link
    link_to user.company_name, "http://#{user.company_url}", target: "_blank"
  end
  
end