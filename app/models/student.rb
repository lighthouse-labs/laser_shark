class Student < User

  belongs_to :cohort
  has_many :day_feedbacks, foreign_key: :user_id
  has_many :feedbacks
  
  scope :in_active_cohort, -> { joins(:cohort).merge(Cohort.is_active) }
  scope :has_open_requests, -> {
    joins(:assistance_requests).
    where(assistance_requests: {type: nil, canceled_at: nil, assistance_id: nil}).
    references(:assistance_requests)
  }

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

  def mentor
    if mentor_id
      @teacher = Teacher.find(mentor_id)
      @teacher.full_name if @teacher.mentor?
    else
      'No Mentor'
    end
  end

end
