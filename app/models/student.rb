class Student < User

  belongs_to :cohort

  def prepping?
    self.cohort.nil?
  end

end
