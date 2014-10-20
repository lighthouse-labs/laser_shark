class AssistancesController < ApplicationController

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
    status = assistance.end(params[:assistance][:notes]) ? 200 : 400

    respond_to do |format|
      format.json { render(:nothing => true, :status => status) }
      format.all { redirect_to(assistance_requests_path) }
    end
  end
end
