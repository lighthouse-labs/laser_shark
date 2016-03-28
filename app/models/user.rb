class User < ActiveRecord::Base

  mount_uploader :custom_avatar, CustomAvatarUploader

  belongs_to :cohort
  belongs_to :location

  has_many :recordings, foreign_key: :presenter_id

  has_many :assistance_requests, foreign_key: :requestor_id
  has_many :assistances, foreign_key: :assistee_id

  has_many :activity_submissions
  has_many :submitted_activities, through: :activity_submissions, source: :activity

  scope :order_by_last_assisted_at, -> {
    order("last_assisted_at ASC NULLS FIRST")
  }
  scope :cohort_in_locations, -> (locations) {
    if locations.is_a?(Array) && locations.length > 0
      includes(cohort: :location).
      where(locations: {name: locations}).
      references(:cohort, :location)
    end
  }
  scope :active, -> {
    where(deactivated_at: nil, completed_registration: true)
  }
  scope :completed_activity, -> (activity) {
    joins(:activity_submissions).where(activity_submissions: { activity: activity })
  }

  validates :uid,             presence: true
  validates :token,           presence: true
  validates :first_name,      presence: true
  validates :last_name,       presence: true
  validates :phone_number,    presence: true
  validates :email,           email: true
  validates :location_id,     presence: true
  validates :github_username, presence: true

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

  def deactivate!
    update! deactivated_at: Time.now
  end

  def deactivated?
    self.deactivated_at?
  end

  def reactivate!
    update! deactivated_at: nil
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
    !activity.section && submitted_activities.include?(activity)
  end

  def github_url(activity)
    activity_submissions.where(activity: activity).first.github_url if completed_activity?(activity)
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def initials
    "#{self.first_name.first}#{self.last_name.first}"
  end

  def incomplete_activities
    Activity.where.not(id: self.activity_submissions.select(:activity_id)).where("day < ?", CurriculumDay.new(Date.today, cohort).to_s).order(:day).reverse
  end

  def non_code_reviewed_activity_submissions
    @activities_struct = Struct.new(:id, :name)
    @activity_submissions = self.activity_submissions.order(created_at: :desc).with_github_url.select{ |activity_submission| !activity_submission.code_reviewed?}
    .map do |activity_submission|
      @activities_struct.new(activity_submission.id ,activity_submission.activity.name)
    end
  end

  class << self
    def authenticate_via_github(auth)
      @user = where(uid: auth["uid"]).first
      return @user if @user
      @user = new
      @user.uid = auth["uid"]
      @user.save(validate: false)
      @user.update_columns(attributes_from_oauth(auth))
      @user
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
