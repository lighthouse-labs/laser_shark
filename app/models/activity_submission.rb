class ActivitySubmission < ActiveRecord::Base

  belongs_to :user
  belongs_to :activity

  has_one :code_review_request, dependent: :destroy

  #after_save :request_code_review
  after_create :create_feedback
  after_destroy :handle_submission_destroy
  after_destroy :destroy_feedback

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
    if self.activity.allow_submissions? && should_code_review? && self.code_review_request == nil
      self.create_code_review_request(requestor_id: self.user.id)
    end
  end

  def should_code_review?
    return false if user.code_review_percent.nil? || activity.code_review_percent.nil?
    student_probablitiy = user.code_review_percent / 100.0
    activity_probability = activity.code_review_percent / 100.0
    student_probablitiy * activity_probability >= rand
  end

  def create_feedback
    self.activity.feedbacks.create(student: self.user) if self.user.is_a?(Student) && self.activity.allow_feedback?
  end

  def destroy_feedback
    if self.activity.allow_feedback?
       @feedback = self.activity.feedbacks.find_by(student: self.user)
       @feedback.destroy if @feedback
    end
  end

  def handle_submission_destroy
    Pusher.trigger format_channel_name('assistance', self.user.location.name),
    'received', {
      type: "CancelAssistanceRequest",
      object: AssistanceRequestSerializer.new(self.code_review_request, root: false).as_json
    }
  end

end
