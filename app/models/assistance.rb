class Assistance < ActiveRecord::Base

  include Assistance::Notifications

  has_one :assistance_request, dependent: :nullify
  belongs_to :assistor, :class_name => User
  belongs_to :assistee, :class_name => User
  has_one :feedback, as: :feedbackable, dependent: :destroy

  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 4, allow_nil: true }

  before_create :set_start_at
  
  scope :currently_active, -> {
    joins("LEFT OUTER JOIN assistance_requests ON assistance_requests.assistance_id = assistances.id").
    where("assistance_requests.canceled_at IS NULL AND assistances.end_at IS NULL")
  }
  scope :completed, -> { where('assistances.end_at IS NOT NULL') }
  scope :order_by_start, -> { order(:start_at) }
  scope :assisted_by, -> (user) { where(:assistor => user) }
  scope :assisting, -> (user) { where(:assistee => user) }

  RATING_BASELINE = 3

  def end(notes, rating = nil)
    self.notes = notes
    self.rating = rating
    self.end_at = Time.now
    self.save
    self.assistee.last_assisted_at = Time.now
    if assistance_request.instance_of?(CodeReviewRequest) && !rating.nil? && !assistee.code_review_percent.nil?
      assistee.code_review_percent += Assistance::RATING_BASELINE - rating
    end
    
    self.assistee.save.tap do
      self.create_feedback(student: self.assistee, teacher: self.assistor)
      send_notes_to_slack
      send_assistance_ended_socket_messages
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

end
