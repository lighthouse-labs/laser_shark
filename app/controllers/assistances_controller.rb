class AssistancesController < ApplicationController

  before_filter :teacher_required
  before_filter :load_student

  def index
    @assistance_requests = @student.completed_assistance_requests.reverse
    @assistance_requests_count = @assistance_requests.count
    @assistance_requests_average_rating = ((@assistance_requests.inject(0){ |total, ar| total+ar.assistance.rating })/@assistance_requests_count.to_f).round(1)
    @assistance = Assistance.new(assistor: current_user, assistee: @student)
  end

  def create
    @assistance_request = AssistanceRequest.new(requestor: @student, reason: "Offline assistance requested")
    @assistance_request.save!
    @assistance_request.start_assistance(current_user)
    @assistance = @assistance_request.reload.assistance
    @assistance.end(params[:assistance][:notes], params[:assistance][:rating])
    redirect_to :back
  end

  private

  def teacher_required
    redirect_to(:root, alert: 'Not allowed') unless teacher?
  end

  def load_student
    @student = Student.find(params[:student_id])
  end

end
