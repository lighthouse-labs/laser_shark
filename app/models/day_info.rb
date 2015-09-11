class DayInfo < ActiveRecord::Base

  validates :day, uniqueness: true, format: {with: /\Aw[1-8]d[1-#{DAYS_PER_WEEK}]\z/}

end
