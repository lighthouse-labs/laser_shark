class Student < User

  belongs_to :cohort
  has_many :day_feedbacks, foreign_key: :user_id
  has_many :feedbacks
  has_one :mentor, class_name: 'Teacher', foreign_key: 'mentor_id'
  
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

  def completed_code_reviews
    assistance_requests.where(type: 'CodeReviewRequest').where.not(assistance_requests: {assistance_id: nil})
  end

  def assistances_received
    assistance_requests.where(type: nil).where.not(assistance_requests: {assistance_id: nil})
  end

  def activites_with_github_submission
    self.activity_submissions
  end
end
