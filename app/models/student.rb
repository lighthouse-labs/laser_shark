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
    assistance_requests.where(type: 'CodeReviewRequest').where.not(assistance_requests: {assistance_id: nil}).includes(:assistance).where.not(assistances: {rating: nil})
  end

  def completed_assistance_requests
    assistance_requests.where(type: nil).where.not(assistance_requests: {assistance_id: nil}).includes(:assistance).where.not(assistances: {rating: nil})
  end

  def activites_with_github_submission
    self.activity_submissions
  end

  def l_score
    @code_review_requests = completed_code_review_requests
    @assistance_requests = completed_assistance_requests

    @code_review_requests_total = @code_review_requests.count
    @assistance_requests_total = @assistance_requests.count

    if (@code_review_requests_total + @assistance_requests_total > 0)
      @code_review_requests_rating_sum = @code_review_requests.inject(0){ |total, code_review_request| total + (code_review_request.assistance.rating || 3) }
      @assistance_requests_rating_sum = @assistance_requests.inject(0){ |total, assistance_request| total + (assistance_request.assistance.rating || 3) }
      ((@code_review_requests_rating_sum + @assistance_requests_rating_sum).to_f/(@code_review_requests_total + @assistance_requests_total)).round(1)
    else  
      return 'No score yet'       
    end
  end
  
end
