module CodeReviewHelper

  def completed_review_button(code_review)

    classes = "btn btn-sm view-code-review-button"

    classes += case code_review.assistance.rating
      when 1
        ' btn-danger'  
      when 2
        ' btn-warning'
      when 3
        ' btn-info'
      when 4
        ' btn-success'
      end

    content_tag(:div, class: classes, data: { toggle: 'modal', target: '#view_code_review_modal', 'code-review-assistance-id' => code_review.assistance.id}) do
      "View"
    end

  end

end
