class AssistanceRequestsController < ApplicationController
  
  def index
    @requests = AssistanceRequest.open_requests.oldest_requests_first
  end

  #ajax only
  def new
    ar = AssistanceRequest.new(:requestor => current_user)
    if ar.save
      render :nothing => true, :status => 200
    else
      render :nothing => true, :status => 400
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