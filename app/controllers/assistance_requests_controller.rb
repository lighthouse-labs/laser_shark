class AssistanceRequestsController < ApplicationController

  def index
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
    ar.start_assistance(current_user)
  end

  def end_assistance
    params.permit(:note)

    ar = AssistanceRequest.find(params[:id].to_i)
    ar.end_assistance(params[:note])
  end
end