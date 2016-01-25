class CodeReviewsController < ApplicationController

  before_filter :teacher_required
  before_filter :load_student

  def create
    @code_review_request = CodeReviewRequest.new(requestor: @student, activity_submission_id: params[:activity_submission_id])
    @code_review_request.save!
    @code_review_request.start_assistance(current_user)
    @code_review = @code_review_request.reload.assistance
    @code_review.end(params[:code_review][:notes], params[:code_review][:rating].to_i, params[:code_review][:student_notes])
    UserMailer.new_code_review_message(@code_review).deliver if params[:activity_submission_id]
    redirect_to :back
  end

  def view_code_review_modal
    @code_review_assistance = CodeReview.find(params[:id])
    render layout: false
  end

  private

  def teacher_required
    redirect_to(:root, alert: 'Not allowed') unless teacher?
  end

  def load_student
    id = params["student_id"] || params["assistee-id"]
    puts "the id is: #{id}"
    @student = Student.find(id)
  end

end
