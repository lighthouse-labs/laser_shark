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

end
