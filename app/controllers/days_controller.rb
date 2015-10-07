class DaysController < ApplicationController

  include CourseCalendar # concern

  def show
    @activities = Activity.chronological.for_day(day)
    if student?
      # Teachers dont have feedbacks associated with their model
      @day_feedback = current_user.day_feedbacks.new 
    elsif teacher?
      feedback = DayFeedback.for_day(day)
      @feedback = {
        happy: feedback.happy.count,
        ok:    feedback.ok.count,
        sad:   feedback.sad.count
      }
      @cohort_feedback = {
        happy: feedback.from_cohort(cohort).happy.count,
        ok:    feedback.from_cohort(cohort).ok.count,
        sad:   feedback.from_cohort(cohort).sad.count
      }
    end
  end

end