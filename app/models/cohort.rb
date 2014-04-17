class Cohort < ActiveRecord::Base
  has_many :day_units
  has_many :students
  validates :name, presence: true
  validates :start_date, presence: true
end
