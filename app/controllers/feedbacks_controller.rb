class FeedbacksController < ApplicationController
  before_filter :student_required

  def show
    @completed_feedbacks = current_user.feedbacks.completed
    # @pending_feedbacks = Feedback.pending(current_user)
  end

  private

  def student_required
    redirect_to(:root, alert: 'Not allowed') unless student?
  end
end
