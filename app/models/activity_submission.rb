class ActivitySubmission < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity
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
    CodeReviewRequest.create(requestor_id: self.user.id)
  end

end
