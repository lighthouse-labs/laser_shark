class AssistanceRequest < ActiveRecord::Base
  belongs_to :requestor, :class => User
  belongs_to :assistance
  belongs_to :activity_submission

  validates :requestor, :presence => true

  before_create :set_start_at

  scope :open_requests, -> { where(:canceled_at => nil).where(:assistance_id => nil) }
  scope :open_or_inprogress_requests, -> {
    joins("LEFT OUTER JOIN assistances ON assistances.id = assistance_requests.assistance_id").
    where("assistance_requests.canceled_at IS NULL AND (assistances.id IS NULL OR assistances.end_at IS NULL)")
  }
  scope :oldest_requests_first, -> { order(:start_at) }
  scope :requested_by, -> (user) { where(:requestor => user) }
  scope :code_reviews, -> {where(:type => 'CodeReviewRequest')}

  def cancel
    self.canceled_at = Time.now
    save
  end

  def start_assistance(assistor)
    return false if assistor.blank? || !self.assistance.blank?
    self.assistance = Assistance.new(:assistor => assistor, :assistee => self.requestor)
    self.assistance.save
  end

  def end_assistance(notes)
    return if self.assistance.blank?
    self.assistance.end(notes)
  end

  def self.oldest_open_request_for_user(user)
    AssistanceRequest.open_requests.requested_by(user).oldest_requests_first.first
  end

  def is_open?
    assistance.nil? && canceled_at.nil?
  end

  private

  def set_start_at
    self.start_at = Time.now
  end

end
