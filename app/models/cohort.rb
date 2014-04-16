class Cohort < ActiveRecord::Base
  has_many :students
  validates :name, presence: true
  validates :start_date, presence: true
end
