class Activity < ActiveRecord::Base

  validates :name, presence: true, length: { maximum: 56 }
  validates :day, numericality: { only_integer: true, minimum: 1 }

end
