class DayFeedbacksPresenter < BasePresenter
  presents :dayfeedbacks

  def total_count
    dayfeedbacks.count.to_f.round(0)
  end

  def total
    if total_count != 0
      total_count
    else
      false
    end
  end

  def happy_total
    total ? dayfeedbacks.happy.count.to_f.round(0) : 0
  end

  def ok_total
    total ? dayfeedbacks.ok.count.to_f.round(0) : 0
  end

  def sad_total
    total ? dayfeedbacks.sad.count.to_f.round(0) : 0
  end

  def happy_percentage
    total ? (happy_total.to_f/total*100).round(0) : 0
  end

  def ok_percentage
    total ? (ok_total.to_f/total*100).round(0) : 0
  end

  def sad_percentage
    total ? (sad_total.to_f/total*100).round(0) : 0
  end

  def day
    dayfeedbacks.day.upcase
  end
end