module CohortsHelper

  def cohort_link(cohort)
    if current_user && current_user.cohort == cohort
      cohort.name + " *"
    else
      cohort.name
    end
  end

  def cohort_status(cohort)
    if cohort.active?
      content_tag :span,  'Active', class: 'label label-success'
    elsif cohort.finished?
      content_tag :span, 'Finished', class: 'label label-danger'
    else
      content_tag :span, 'Upcoming', class: 'label label-info'
    end
  end

end
