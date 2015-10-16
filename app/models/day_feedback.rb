class DayFeedback < ActiveRecord::Base
	
  belongs_to :student, foreign_key: :user_id
  
  validates :title, presence: true
  validates :text,  presence: true
  validates :day,   presence: true
  validates :mood,  presence: true

  scope :for_day, -> (day) { where(day: day.to_s) }
  scope :happy,   -> { where(mood: 'happy') }
  scope :ok,      -> { where(mood: 'ok') }
  scope :sad,     -> { where(mood: 'sad') }

  scope :from_cohort, -> (cohort) { joins(:student).where('users.cohort_id =? ', cohort.id) }
  scope :reverse_chronological_order, -> { order(created_at: :desc) }
  scope :archived, -> { where("archived_at IS NOT NULL") }
  scope :unarchived, -> { where("archived_at IS NULL") }

  scope :filter_by_mood, -> (mood) { where(mood: mood) }
  scope :filter_by_day, -> (day) { where("day LIKE ?", day.downcase+"%") }
  scope :filter_by_location, -> (location_id) { 
    includes(student: :location).
    references(:student, :location).
    where(locations: {id: location_id})
  }

  after_create :notify_admin

  private

  def notify_admin
    AdminMailer.new_day_feedback(self).deliver
  end

  def self.filter_by(options)
    options.inject(all) do |result, (k, v)|
      attribute = k.gsub("_id", "")
      if attribute == 'archived?'
        result = self.filter_by_archived(v, result)
      else
        result = result.send("filter_by_#{attribute}", v)
      end   
    end
  end

  def self.filter_by_archived(value, result)
    if value == 'true'
      result = result.archived
    else
      result = result.unarchived
    end
  end

end
