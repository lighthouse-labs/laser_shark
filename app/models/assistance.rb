class Assistance < ActiveRecord::Base
  has_one :assistance_request, dependent: :nullify
  belongs_to :assistor, :class_name => User
  belongs_to :assistee, :class_name => User
  has_one :feedback, as: :feedbackable, dependent: :destroy
  

  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 4, allow_nil: true }

  before_create :set_start_at

  scope :currently_active, -> {
    joins(:assistance_request).
    where("assistance_requests.canceled_at IS NULL AND assistances.end_at IS NULL")
  }
  scope :completed, -> { where('assistances.end_at IS NOT NULL') }
  scope :order_by_start, -> { order(:start_at) }
  scope :assisted_by, -> (user) { where(:assistor => user) }
  scope :assisting, -> (user) { where(:assistee => user) }

  RATING_BASELINE = 3

  def end(notes, rating = nil, student_notes = nil)
    self.notes = notes
    self.rating = rating
    self.student_notes = student_notes
    self.end_at = Time.now
    self.save
    self.assistee.last_assisted_at = Time.now
    if assistance_request.instance_of?(CodeReviewRequest) && !rating.nil? && !assistee.code_review_percent.nil?
      assistee.code_review_percent += Assistance::RATING_BASELINE - rating
      UserMailer.new_code_review_message(self).deliver
    end

    self.assistee.save.tap do
      self.create_feedback(student: self.assistee, teacher: self.assistor)
      send_notes_to_slack
    end
  end

  def to_json
    return {
      start_time: start_at,
      id: id,
      assistee: {
        avatar_url: assistee.avatar_url,
        full_name: assistee.full_name
      }
    }
  end

  def day
    CurriculumDay.new(self.start_at, self.assistee.cohort).to_s
  end

  private

  def set_start_at
    self.start_at = Time.now
  end

  def send_notes_to_slack
    post_to_slack(ENV['SLACK_CHANNEL'])
    post_to_slack(ENV['SLACK_CHANNEL_REMOTE']) if self.assistee.remote
  end

  def post_to_slack(channel)
    return if ENV['SLACK_TOKEN'].nil? || channel.nil?
    options = {
      username: self.assistor.github_username,
      icon_url: self.assistor.avatar_url,
      channel: channel
    }
    begin
      poster = Slack::Poster.new('lighthouse', ENV['SLACK_TOKEN'], options)
      poster.send_message("*Assisted #{self.assistee.full_name} for #{ ((self.end_at - self.start_at)/60).to_i } minutes*:\n #{self.notes}")
    rescue
    end
  end
end
