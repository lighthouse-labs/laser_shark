class FeedbacksController < ApplicationController
  before_filter :student_required
  before_action :load_feedback, only: [:update, :modal_content]

  def index
    @completed_feedbacks = current_user.feedbacks.completed.reverse_chronological_order
    @expired_feedbacks = current_user.feedbacks.pending.reverse_chronological_order.expired
  end

  def update
    @feedback.update(feedback_params)
    if @feedback.save
      redirect_to :back
    else    
      redirect_to(:back, alert: 'Feedback could not be saved')
    end
  end

  def modal_content
    render layout: false
  end

  private

  def student_required
    redirect_to(:root, alert: 'Not allowed') unless student?
  end

  def feedback_params
    params.require(:feedback).permit(
      :notes, :rating
    )
  end

  def load_feedback
    @feedback = Feedback.find(params[:id].to_i)
  end
end
