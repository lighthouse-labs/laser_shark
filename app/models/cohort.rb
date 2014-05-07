class Cohort < ActiveRecord::Base

  has_many :students
  validates :name, presence: true
  validates :start_date, presence: true

  scope :most_recent, -> { order(start_date: :desc) }

end
