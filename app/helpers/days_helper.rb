module DaysHelper

  def day_status_css(day)
    classes = []
    classes.push('disabled') if day > today
    classes.push('active') if day == @day
    classes.push('today') if day == today
    classes.push('unlocked') if day < today
    classes
  end

end
