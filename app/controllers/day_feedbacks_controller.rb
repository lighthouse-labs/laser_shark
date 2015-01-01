class DayFeedbacksController < ApplicationController

  include CourseCalendar

  def create
  	@day_feedback = current_user.day_feedbacks.new(day_feedback_params)
    @day_feedback.day = params[:day_number]
  	if @day_feedback.save
  		flash[:success] = "Your feedback was submitted successfully"
      redirect_to day_path(params[:day_number])
    else
      @activities = Activity.chronological.for_day(day)
      render 'days/show'
    end
  
  end

  private
  	def day_feedback_params
  		params.require(:day_feedback).permit(
  			:mood, :title, :text
  		)
  	end
end
