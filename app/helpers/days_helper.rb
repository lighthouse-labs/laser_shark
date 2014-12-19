module DaysHelper

  def day_status_css(day)
    classes = []
    classes.push('disabled') unless current_user.can_access_day?(day)
    classes.push('active') if day == @day
    classes.push('today') if day == today
    classes.push('unlocked') if day < today
    classes
  end

  def feedback_submitted?
    current_user.day_feedbacks.find_by(day: @day).nil? if student?
  end
end
