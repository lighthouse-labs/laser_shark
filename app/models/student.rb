class Student < User

  belongs_to :cohort
  has_many :day_feedbacks, foreign_key: :user_id
  
  scope :in_active_cohort, -> { joins(:cohort).merge(Cohort.is_active) }

  def prepping?
    self.cohort.nil?
  end

  def prospect?
    false
  end

  def active_student?
    !prepping? && cohort.active?
  end

  def alumni?
    !prepping? && cohort.finished?
  end

end
