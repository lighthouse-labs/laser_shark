class DayInfo < ActiveRecord::Base

  validates :day, uniqueness: true, format: {with: DAY_REGEX}

end
