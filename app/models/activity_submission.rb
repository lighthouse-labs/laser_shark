class ActivitySubmission < ActiveRecord::Base

  # => Serialize the data field
  serialize :data
  
  belongs_to :user
  belongs_to :activity
  
  has_one :code_review_request, dependent: :destroy
  
  before_create :check_data_for_finalized

  #after_save :request_code_review
  after_create :create_feedback
  after_create :create_user_outcome_results
  after_destroy :handle_submission_destroy
  after_destroy :destroy_feedback

  default_value_for :completed_at, allows_nil: false do
    Time.now
  end

  validates :user_id, uniqueness: { 
    scope: :activity_id,
    message: "only one submission per activity" 
  }, if: Proc.new {|activity_submission| !activity_submission.activity.section}

  validates :github_url, 
    presence: :true, 
    format: { with: URI::regexp(%w(http https)), message: "must be a valid format" },
    if: :github_url_required?

  scope :with_github_url, -> {
    includes(:activity).
    where(activities: {allow_submissions: true}).
    references(:activity)
  }

  scope :not_code_reviewed, -> {
    where(code_review_request: nil)
  }
  
  def code_reviewed?
    self.try(:code_review_request).try(:assistance)
  end

  private

  def check_data_for_finalized
    unless self.data.blank?
      # => TODO handle more than just prep data
      data = get_prep_code_result_data

      self.finalized = data[:lint_results].zero? && data[:test_failures].zero?
    end

    # => Return true so it saves!
    true
  end

  def get_prep_code_result_data
    {
      lint_results: self.data["lintResults"],
      test_failures: self.data["testFailures"],
      test_passes: self.data["testPasses"]
    }
  end

  def github_url_required?
    activity && activity.allow_submissions? && !activity.prep?
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
    ActionCable.server.broadcast "assistance", {
      type: "CancelAssistanceRequest",
      object: AssistanceRequestSerializer.new(self.code_review_request, root: false).as_json
    }
  end

  def create_user_outcome_results
    self.activity.activity_outcomes.each do |activity_outcome|
      # => TODO: change the way we calculate ratings
      if self.activity.prep?
        self.user.outcome_results.create(outcome: activity_outcome.outcome, resultable: activity_outcome, rating: Prep.evaluate_rating(get_prep_code_result_data))
      end
    end
  end

end
