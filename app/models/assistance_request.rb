class AssistanceRequest < ActiveRecord::Base

  include AssistanceRequest::Notifications

  belongs_to :requestor, :class_name => User
  belongs_to :assistance, dependent: :delete
  belongs_to :activity_submission

  validates :requestor, :presence => true

  before_create :limit_one_per_user
  before_create :set_start_at
  
  scope :open_requests, -> { where(:canceled_at => nil).where(:assistance_id => nil) }
  scope :in_progress_requests, -> {
    includes(:assistance).
    where(assistance_requests: {canceled_at: nil}).
    where.not(assistances: {id: nil}).
    where(assistances: {end_at: nil}).
    references(:assistance)
  }
  scope :open_or_in_progress_requests, -> {
    includes(:assistance).
    where(assistance_requests: {canceled_at: nil}).
    where("assistances.id IS NULL OR assistances.end_at IS NULL").
    references(:assistance)
  }
  scope :requestor_cohort_in_locations, -> (locations) {
    if locations.is_a?(Array) && locations.length > 0
      includes(requestor: {cohort: :location}).
      where(locations: {name: locations}).
      references(:requestor, :cohort, :location)
    end
  }
  scope :oldest_requests_first, -> { order(start_at: :asc) }
  scope :newest_requests_first, -> { order(start_at: :desc) }
  scope :requested_by, -> (user) { where(:requestor => user) }
  scope :code_reviews, -> { where(:type => 'CodeReviewRequest') }

  def cancel
    self.canceled_at = Time.now
    send_destroy_socket_messages
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

  def cancel_assistance
    self.assistance = nil
    self.save
  end

  def open?
    assistance.nil? && canceled_at.nil?
  end

  def in_progress?
    canceled_at.nil? && assistance && assistance.end_at.nil?
  end

  def position_in_queue
    self.class.open_requests.where(type: nil).requestor_cohort_in_locations([requestor.cohort.location.name]).where('assistance_requests.id < ?', id).count + 1 if open?
  end

  private

  def set_start_at
    self.start_at = Time.now
  end

  def limit_one_per_user
    if type.nil? && requestor.assistance_requests.where(type: nil).open_or_in_progress_requests.exists?
      errors.add :base, 'Limit one open/in progress request per user'
      false
    end
  end

end
