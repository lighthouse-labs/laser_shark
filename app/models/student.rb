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

  def completed_code_review_requests
    assistance_requests.where(type: 'CodeReviewRequest').where.not(assistance_requests: {assistance_id: nil}).includes(:assistance)
  end

  def code_reviews_l_score
    completed_code_reviews = completed_code_review_requests
    if completed_code_reviews.length > 0
      (completed_code_reviews.inject(0){|sum, code_review| sum+= code_review.assistance.rating})/(completed_code_reviews.length.to_f).round(1)
    else
      'N/A'
    end
  end

end
