class Cohort < ActiveRecord::Base

  belongs_to :program
  belongs_to :location

  has_many :students
  has_many :recordings
  
  validates :name, presence: true
  validates :start_date, presence: true
  validates :program, presence: true
  validates :location, presence: true

  validates :code,  uniqueness: true, 
                    presence: true,
                    format: { with: /\A[-a-z]+\z/, allow_blank: true }, 
                    length: { minimum: 3, allow_blank: true }

  scope :most_recent, -> { order(start_date: :desc) }

  scope :is_active, -> { where("cohorts.start_date >= ? AND cohorts.start_date <= ?", Date.current - 8.weeks, Date.current) }
  scope :starts_between, -> (from, to){ where("cohorts.start_date >= ? AND cohorts.start_date <= ?", from, to) }

  def active?
    start_date >= (Date.current - 8.weeks) && start_date <= Date.current
  end

  def finished?
    start_date < (Date.current - 8.weeks)
  end

end
