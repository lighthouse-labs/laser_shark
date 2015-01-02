class Cohort < ActiveRecord::Base

  has_many :students
  validates :name, presence: true
  validates :start_date, presence: true
  validates :code, uniqueness: true

  scope :most_recent, -> { order(start_date: :desc) }

  scope :is_active, -> { where("cohorts.start_date >= ? AND cohorts.start_date <= ?", Date.current - 8.weeks, Date.today) }

  def active?
    start_date >= (Date.current - 8.weeks) && start_date <= Date.today
  end

  def finished?
    start_date < (Date.current - 8.weeks)
  end

end
