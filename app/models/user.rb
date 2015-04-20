class User < ActiveRecord::Base

  mount_uploader :custom_avatar, CustomAvatarUploader

  belongs_to :cohort

  has_many :assistance_requests, foreign_key: :requestor_id
  has_many :assistances, foreign_key: :assistee_id

  has_many :activity_submissions
  has_many :submitted_activities, through: :activity_submissions, source: :activity

  scope :order_by_last_assisted_at, -> {
    order("last_assisted_at ASC NULLS FIRST")
  }

  scope :active, -> {
    where(deactivated_at: nil, completed_registration: true)
  }

  validates :uid,   presence: true
  validates :token, presence: true

  def prospect?
    true
  end

  def prepping?
    false
  end

  def active_student?
    false
  end

  def alumni?
    false
  end

  def deactivate
    self.deactivated_at = Time.now
  end

  def deactivated?
    self.deactivated_at?
  end

  def reactivate
    self.deactivated_at = nil
  end

  def unlocked?(day)
    # for special students we can unlock future material using `unlocked_until_day` field
    (unlocked_until_day? && day.to_s <= unlocked_until_day) || day.unlocked?
  end

  def can_access_day?(day)
    unlocked? CurriculumDay.new(day, cohort)
  end

  def being_assisted?
    self.assistance_requests.where(type: nil).in_progress_requests.exists?
  end

  def position_in_queue
    self.assistance_requests.where(type: nil).open_requests.newest_requests_first.first.try(:position_in_queue)
  end

  def current_assistor
    self.assistance_requests.where(type: nil).in_progress_requests.newest_requests_first.first.try(:assistance).try(:assistor)
  end

  def waiting_for_assistance?
    self.assistance_requests.where(type: nil).open_requests.exists?
  end

  def completed_activity?(activity)
    submitted_activities.include?(activity)
  end

  def github_url(activity)
    activity_submissions.where(activity: activity).first.github_url if completed_activity?(activity)
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  class << self
    def authenticate_via_github(auth)
      where(uid: auth["uid"]).first_or_create(attributes_from_oauth(auth))
    end

    private

    def attributes_from_oauth(auth)
      {
        token: auth["credentials"]["token"],
        github_username: auth["info"]["nickname"],
        first_name: auth["info"]["name"].to_s.split.first,
        last_name: auth["info"]["name"].to_s.split.last,
        avatar_url: auth["info"]["image"],
        email: auth["info"]["email"]
      }
    end
  end

end
