class AssistanceRequestsController < ApplicationController

  def index
    @my_active_assistances = Assistance.currently_active.assisted_by(current_user)
    @requests = AssistanceRequest.open_requests.oldest_requests_first
  end

  def create
    ar = AssistanceRequest.new(:requestor => current_user)
    status = ar.save ? 200 : 400
    respond_to do |format|
      format.json { render(:nothing => true, :status => status) }
      format.all { redirect_to(assistance_requests_path) }
    end
  end

  def cancel
    ar = AssistanceRequest.oldest_open_request_for_user(current_user)
    status = ar.cancel ? 200 : 400

    respond_to do |format|
      format.json { render(:nothing => true, :status => status) }
      format.all { redirect_to(assistance_requests_path) }
    end
  end

  def start_assistance
    ar = AssistanceRequest.find(params[:id].to_i)
    status = ar.start_assistance(current_user) ? 200 : 400

    respond_to do |format|
      format.json { render(:nothing => true, :status => status) }
      format.all { redirect_to(assistance_requests_path) }
    end
  end

  def end_assistance
    params.permit(:assistance).permit(:notes)

    ar = AssistanceRequest.find(params[:id].to_i)
    status = ar.end_assistance(params[:assistance][:notes]) ? 200 : 400

    respond_to do |format|
      format.json { render(:nothing => true, :status => status) }
      format.all { redirect_to(assistance_requests_path) }
    end
  end
end