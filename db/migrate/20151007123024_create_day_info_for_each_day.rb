class CreateDayInfoForEachDay < ActiveRecord::Migration
  def up
    Activity.select(:day).collect(&:day).each do |day|
      DayInfo.find_or_create_by(day: day)
    end
  end

  def down

  end
end
