class CodeReviewsController < ApplicationController

  before_filter :teacher_required
  before_filter :load_student, except: [:view_code_review_modal]

  def index
    @assistance_requests = @student.completed_assistance_requests.reverse
    @assistance_requests_count = @assistance_requests.count
    @assistance_requests_average_rating = ((@assistance_requests.inject(0){ |total, ar| total+ar.CodeReview.rating })/@assistance_requests_count.to_f).round(1)
    @assistance = CodeReview.new(assistor: current_user, assistee: @student)
  end

  def create
    @assistance_request = CodeReviewRequest.new(requestor: @student, activity_submission_id: params[:activity_submission_id])
    @assistance_request.save!
    @assistance_request.start_assistance(current_user)
    @assistance = @assistance_request.reload.assistance
    @assistance.end(params[:code_review][:notes], params[:code_review][:rating].to_i, params[:code_review][:student_notes])
    UserMailer.new_code_review_message(@assistance).deliver if params[:activity_submission_id]
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
    @student = Student.find(params[:student_id])
  end

end
