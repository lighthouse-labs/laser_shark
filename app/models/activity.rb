class Activity < ActiveRecord::Base

  belongs_to :section
  
  has_many :activity_submissions, -> { order(:user_id) }
  has_many :messages, -> { order(created_at: :desc) }, class_name: 'ActivityMessage'
  has_many :recordings, -> { order(created_at: :desc) }
  has_many :feedbacks, as: :feedbackable

  has_many :activity_outcomes, dependent: :destroy
  has_many :outcomes, through: :activity_outcomes

  has_one :activity_test
  accepts_nested_attributes_for :activity_test

  validates :name, presence: true, length: { maximum: 56 }
  validates :duration, numericality: { only_integer: true }
  validates :start_time, numericality: { only_integer: true }, if: Proc.new{|activity| activity.section.blank?}
  validates :day, presence: true, format: { with: DAY_REGEX, allow_blank: true }, if: Proc.new{|activity| activity.section.blank?}

  scope :chronological, -> { order("start_time, id") }
  scope :for_day, -> (day) { where(day: day.to_s) }
  scope :search, -> (query) { where("lower(name) LIKE :query or lower(day) LIKE :query", query: "%#{query.downcase}%") }

  # Below hook should really be after_save (create and update)
  # However, when seeding/mass-creating activties, github API will return error
  after_update :add_revision_to_gist

  # Given the start_time and duration, return the end_time
  def end_time
    hours = start_time / 100
    minutes = start_time % 100
    duration_hours = duration / 60
    duration_minutes = duration % 60

    if duration_minutes + minutes >= 60
      hours += 1
      minutes = (duration_minutes + minutes) % 60
      duration_minutes = 0
    end

    return (hours + duration_hours) * 100 + (minutes + duration_minutes)
  end

  def next
    if prep?
      self.section.activities.where('activities.id > ?', self.id).first
    else
      Activity.where('start_time > ? AND day = ?', self.start_time, self.day).order(start_time: :asc).first
    end
  end

  def previous
    if prep?
      self.section.activities.where('activities.id < ?', self.id).last
    else
      Activity.where('start_time < ? AND day = ?', self.start_time, self.day).order(start_time: :desc).first
    end
  end

  def display_duration?
    type != 'Lecture' && type != 'Test'
  end

  def prep?
    self.section
  end

  protected

  def add_revision_to_gist
    g = ActivityRevision.new(self)
    g.commit
  end

  def gist_id
    self.gist_url.split('/').last
  end

end
