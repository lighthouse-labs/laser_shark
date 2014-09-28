class Cohort < ActiveRecord::Base

  has_many :students
  validates :name, presence: true
  validates :start_date, presence: true

  scope :most_recent, -> { order(start_date: :desc) }

  scope :is_active, -> { where("cohorts.start_date >= ?", Date.current - 8.weeks) }

end
