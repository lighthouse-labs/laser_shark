module CohortsHelper

  def cohort_link(cohort)
    if current_user && current_user.cohort == cohort
      cohort.name + " *"
    else
      cohort.name
    end
  end
end
