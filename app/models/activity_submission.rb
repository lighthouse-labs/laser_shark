class ActivitySubmission < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity
  has_one :code_review_request
  
  after_save :request_code_review

  default_value_for :completed_at, allows_nil: false do
    Time.now
  end

  validates :user_id, uniqueness: { scope: :activity_id,
    message: "only one submission per activity" }

  validates :github_url, 
    presence: :true, 
    format: { with: URI::regexp(%w(http https)), message: "must be a valid format" },
    if: :github_url_required?

  private

  def github_url_required?
    activity && activity.allow_submissions?
  end

  def request_code_review
    if self.activity.allow_submissions? && should_code_review?
      CodeReviewRequest.create(activity_submission: self, requestor_id: self.user.id)
    end
  end

  def should_code_review?
    # TODO Vary these probabilities
    student_probablitiy = 0.8
    assignment_probability = 0.6
    student_probablitiy * assignment_probability >= rand
  end

end
