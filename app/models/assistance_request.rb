class AssistanceRequest < ActiveRecord::Base
  belongs_to :requestor, :class => User
  belongs_to :assistance

  validates :requestor, :presence => true

  before_create :set_start_at

  scope :open_requests, -> { where(:assistance_id => nil) }
  scope :oldest_requests_first, -> { order(:start_at) }
  scope :requested_by, -> (user) { where(:requestor => user) }

  def start_assistance(assistor)
    return false if assistor.blank? || !self.assitance.blank?
    self.assistance = Assistance.new(:assistor => assistor, :assistee => self.requestor)
    self.assistance.save
  end

  def end_assistance(notes)
    return if assistance.blank?
    self.assistance.end(notes)
  end

  private

  def set_start_at
    self.start_at = Time.now
  end

end