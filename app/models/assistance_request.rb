class AssistanceRequest < ActiveRecord::Base
  belongs_to :requestor, :class => User
  belongs_to :assistance

  validates :requestor, :presence => true

  before_create :set_start_at

  scope :open_requests, -> { where(:assistance_id => nil).where(:canceled_at => nil) }
  scope :oldest_requests_first, -> { order(:start_at) }
  scope :requested_by, -> (user) { where(:requestor => user) }

  def cancel
    self.canceled_at = Time.now
    save
  end

  def start_assistance(assistor)
    return false if assistor.blank? || !self.assitance.blank?
    self.assistance = Assistance.new(:assistor => assistor, :assistee => self.requestor)
    self.assistance.save
  end

  def end_assistance(notes)
    return if assistance.blank?
    self.assistance.end(notes)
  end

  def self.oldest_open_request_for_user(user)
    AssistanceRequest.open_requests.requested_by(user).oldest_requests_first.first
  end

  private

  def set_start_at
    self.start_at = Time.now
  end

end