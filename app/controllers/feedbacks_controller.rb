class FeedbacksController < ApplicationController
  before_filter :student_required

  def index
    @completed_feedbacks = current_user.feedbacks.completed
  end

  def update
    @feedback = Feedback.find(params[:id].to_i)
    @feedback.update(feedback_params)
    @feedback.save
    redirect_to :back
  end

  def modal_content
    @feedback = Feedback.find(params[:id].to_i)
    render layout: false
  end

  private

  def student_required
    redirect_to(:root, alert: 'Not allowed') unless student?
  end

  def feedback_params
    params.require(:feedback).permit(
      :technical_rating, :style_rating, :notes
    )
  end
end
