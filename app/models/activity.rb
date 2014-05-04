class Activity < ActiveRecord::Base

  validates :name, presence: true, length: { maximum: 56 }
  validates :day, format: { with: /\A(w\dd\d)|(w\de\d)\z/ }

  scope :chronological, -> { order(:start_time) }
  scope :for_day, -> (day) { where(day: day) }

end
