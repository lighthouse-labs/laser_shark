module CodeReviewHelper

  def completed_review_button(code_review)

    classes = "btn btn-sm view-code-review-button"

    classes += case code_review.assistance.rating
      when 1
        ' btn-danger'
      when 2
        ' btn-warning'
      when 3
        ' btn-success'
      when 4
        ' btn-info'
      end

    content_tag(:div, class: classes, data: { toggle: 'modal', target: '#view_code_review_modal', 'code-review-assistance-id' => code_review.assistance.id}) do
      content = content_tag(:span, code_review.assistance.assistor.initials)
      content << tag(:br)
      if code_review.activity
        content << content_tag(:span, code_review.activity.name.truncate(20), href: "#", data: {toggle: "tooltip" }, title: code_review.activity.name)
        content << tag(:br)
      end
      content << content_tag(:span, code_review.assistance.created_at.to_date, class: 'small')
    end

  end

end
