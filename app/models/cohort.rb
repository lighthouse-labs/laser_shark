class Cohort < ActiveRecord::Base
  has_many :day_units
  has_many :students
  validates :name, presence: true
end
