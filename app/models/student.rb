class Student < User

  belongs_to :cohort

  scope :in_active_cohort, -> { joins(:cohort).merge(Cohort.is_active) }

  def prepping?
    self.cohort.nil?
  end

end
