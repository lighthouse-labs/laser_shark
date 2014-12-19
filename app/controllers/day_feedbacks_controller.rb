# require 'pry'
class DayFeedbacksController < ApplicationController

  def create
    	@day_feedback = DayFeedback.new(day_feedback_params)
      @day_feedback.user_id = current_user.id if current_user
    	if @day_feedback.save
    		flash[:success] = "Your feedback was submitted successfully"
      end
      # binding.pry
    	redirect_to :back
  end

  private
  	def day_feedback_params
  		params.require(:day_feedback).permit(
  			:mood, :title, :text, :day
  		)
  	end
end
