class AssistancesController < ApplicationController

  before_filter :teacher_required

  def index
    @student = Student.find(params[:student_id])
    @assistance_requests = @student.assistances_received.reverse
    @assistance_requests_count = @assistance_requests.count
  end

  def create
    @student = Student.find(params[:student_id])
    @assistance_request = AssistanceRequest.new(requestor: @student, reason: "Offline assistance requested")
    if @assistance_request.save
      @assistance_request.start_assistance(current_user)
      @assistance = @assistance_request.reload.assistance
      # @assistance.end(params[:assistance][:notes], params[:assistance][:rating])
    end
  end

  private

  def teacher_required
    redirect_to(:root, alert: 'Not allowed') unless teacher?
  end

end
