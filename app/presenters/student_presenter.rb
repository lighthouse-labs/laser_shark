class StudentPresenter < UserPresenter
  
  presents :student

  delegate :cohort, to: :student

end