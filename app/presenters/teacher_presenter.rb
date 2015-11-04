class TeacherPresenter < UserPresenter
  presents :teacher

  delegate :feedbacks, to: :teacher

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

  def average_technical_rating
    "Average Technical Rating: #{teacher.feedbacks.average(:technical_rating).to_f.round(2)}/5"
  end

  def average_style_rating
    "Average Style Rating: #{teacher.feedbacks.average(:style_rating).to_f.round(2)}/5"
  end

  protected

  def company_link
    link_to user.company_name, "http://#{user.company_url}", target: "_blank"
  end
  
end