class Activity < ActiveRecord::Base

  validates :name, presence: true, length: { maximum: 56 }
  validates :day, numericality: { only_integer: true, minimum: 1 }

  scope :chronological, -> { order(:start_time) }
  scope :for_day, -> (day) { where(day: day) }

end
