class AssistancesController < ApplicationController

  before_filter :teacher_required

  def index
    @student = Student.find(params[:student_id])
    @assistance_requests = @student.assistances_received.reverse
    @assistance_requests_count = @assistance_requests.count
  end

  def create
    @student = Student.find params[:student_id]
    assistance = Assistance.new(:assistor => current_user, :assistee => @student)
    status = assistance.save ? 200 : 400
    respond_to do |format|
      format.json { render(:nothing => true, :status => status) }
      format.all { redirect_to(assistance_requests_path) }
    end
  end

  def end
    assistance = Assistance.find(params[:id].to_i)
    status = assistance.end(params[:assistance][:notes], params[:assistance][:rating].to_i) ? 200 : 400

    respond_to do |format|
      format.json { render(:nothing => true, :status => status) }
      format.all { redirect_to(assistance_requests_path) }
    end
  end

  def destroy
    assistance = Assistance.find(params[:id].to_i)
    assistance.destroy
    redirect_to assistance_requests_path
  end

  private

  def teacher_required
    redirect_to(:root, alert: 'Not allowed') unless teacher?
  end

end
