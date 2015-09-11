# Not an ActiveRecord model

class CurriculumDay
  attr_reader :date
  attr_reader :raw_date

  include Comparable

  def initialize(date, cohort)
    @raw_date = date
    @date = date
    @cohort = cohort

    @date = @date.to_s if @date.is_a?(CurriculumDay)
    
    if @date.is_a?(String) && @cohort && @date != 'setup'
      @date = calculate_date
    end
  end

  def to_s
    return "setup" if @date == "setup"
    return @to_s if @to_s
    days = (@date.to_date - @cohort.start_date).to_i

    w = (days / 7) + 1
    @to_s = if w > 8
      "w8e"
    elsif @date.sunday? || @date.saturday?
      "w#{w}e"
    else
      d = determine_d
      "w#{w}d#{d}"
    end
  end

  def <=>(other)
    self.date <=> other.date
  end

  def unlocked?
    return true if @date == 'setup'
    return false unless @cohort
    return false if @cohort.start_date > Date.current
    if CURRICULUM_UNLOCKING == 'weekly'
      self.date.cweek <= today.date.cweek
    else # assume daily
      self.date <= today.date 
    end
  end

  def today?
    self.to_s == today.to_s
  end

  def info
    DayInfo.where(day: self.to_s).first
  end

  private

  def today
    @today ||= CurriculumDay.new(Date.current, @cohort)
  end

  def determine_d
    return @date.wday if DAYS_PER_WEEK == 5
    # "d1" would normally be monday, right?
    # Well now it could also be tuesday 
    # Eg Given `WEEKDAYS = [2, 4]` (tuesdays and thursdays)
    # then d1 = tuesday, d2 = thursday
    wday = @date.wday # 1,2,3,4 or 5 (eg: 3 for 'wednesday')
    # 1 (mon) - 1,3 => 1 
    # 2 (tue) - 1,3 => 1
    # 3 (wed) - 1,3 => 3
    # 4 (thu) - 1,3 => 3
    # 5 (fri) - 1,3 => 3
    # 6 (sat) - 1,3 => 3
    # 7 (sun) - 1,3 => 3
    wday = (WEEKDAYS.reverse.detect {|d| d.to_i <= wday } || WEEKDAYS.first)
    WEEKDAYS.index(wday) + 1
  end

  def calculate_date
    date_parts = @date.match(/w(\d+)((d(\d))|e)/).to_a.compact # eg: w5d1 or w4e
    # dow = day of week
    week, dow = date_parts[1].to_i, date_parts.last
    dow = dow == 'e' ? 6 : dow.to_i # weekend is day 6 (saturday)
    
    # limitation: assume start date is always a monday
    # for monday dow = 1 so advance by 0 (no advance) if dow = 1. Hence the -1 offset on dow
    date = @cohort.start_date.monday.advance(weeks: week - 1)
    if DAYS_PER_WEEK == 5
      date = date.advance(days: dow - 1)
    else
      # dow of 2 (d2) may be Tuesday ... but could also be Thursday if we don't have 5 day weeks
      # This would happen if WEEKDAYS = [2, 4]
      # In the example above, d1 = Tuesday, d2 = Thursday
      d = WEEKDAYS[dow - 1].to_i
      date = date.advance(days: d - 1)
    end
    date
  end

end
