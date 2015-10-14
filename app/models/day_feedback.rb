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
  scope :reverse_chronological_order, -> { order(updated_at: :desc) }

  scope :filter_by_mood, -> (mood) { where(mood: mood) }
  scope :filter_by_day, -> (day) { where(day: day.downcase) }
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
      result = result.send("filter_by_#{attribute}", v)
    end
  end

end
