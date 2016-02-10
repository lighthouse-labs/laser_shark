class AssistancesController < ApplicationController

  before_filter :teacher_required

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

  def start_assisting
    data = assistances_params
    ar = AssistanceRequest.find(data["request_id"])
    if ar.start_assistance(current_user)
      Pusher.trigger "assistance-#{ar.requestor.cohort.location.name}",
                     "received", {
                        type: "AssistanceStarted",
                        object: AssistanceSerializer.new(ar.reload.assistance, root: false).as_json
                      }

      Pusher.trigger "UserChannel#{ar.requestor_id}", 'received', {type: "AssistanceStarted", object: UserSerializer.new(current_user).as_json}

      teacher_busy(current_user)
      update_students_in_queue(ar.requestor.cohort.location.name)
    end
    head :ok, content_type: "text/html"
  end

  def end_assistance
    data = assistances_params
    assistance = Assistance.find data["assistance_id"]
    assistance.end(data["notes"], data["rating"].to_i)

    Pusher.trigger "assistance-#{assistance.assistance_request.requestor.cohort.location.name}",
                   "received", {
                     type: "AssistanceEnded",
                     object: AssistanceSerializer.new(assistance, root: false).as_json
                   }

    Pusher.trigger "UserChannel#{assistance.assistance_request.requestor.id}",
                   "received",
                   {type: "AssistanceEnded"}

    teacher_available(current_user)
    head :ok, content_type: "text/html"
  end

  def cancel_assistance_request
    data = assistances_params
    ar = AssistanceRequest.find data["request_id"]
    if ar && ar.cancel
      Pusher.trigger "assistance-#{ar.requestor.cohort.location.name}",
                     "received", {
                        type: "CancelAssistanceRequest",
                        object: AssistanceRequestSerializer.new(ar, root: false).as_json
                      }

      Pusher.trigger "UserChannel#{ar.requestor_id}", 'received', {type: "AssistanceEnded"}
      update_students_in_queue(ar.requestor.cohort.location.name)
    end
    head :ok, content_type: "text/html"
  end

  def stop_assisting
    data = assistances_params
    assistance = Assistance.find data["assistance_id"]
    if assistance && assistance.destroy
      Pusher.trigger "assistance-#{assistance.assistance_request.requestor.cohort.location.name}",
                     "received", {
                       type: "StoppedAssisting",
                       object: AssistanceSerializer.new(assistance).as_json
                     }

      teacher_available(current_user)
      update_students_in_queue(assistance.assistance_request.requestor.cohort.location.name)
    end
    head :ok, content_type: "text/html"
  end

  def provided_assistance
    data = assistances_params
    student = Student.find data["student_id"]
    assistance_request = AssistanceRequest.new(requestor: student, reason: "Offline assistance requested")
    if assistance_request.save
      assistance_request.start_assistance(current_user)
      assistance = assistance_request.reload.assistance
      assistance.end(data["notes"], data["rating"])

      Pusher.trigger "assistance-#{assistance.assistance_request.requestor.cohort.location.name}",
                     "received", {
                       type: "OffineAssistanceCreated",
                       object: UserSerializer.new(student).as_json
                     }
    end
    head :ok, content_type: "text/html"
  end

  private

  def teacher_required
    redirect_to(:root, alert: 'Not allowed') unless teacher?
  end

  def assistances_params
    params.permit(:student_id, :assistance_id, :request_id, :notes, :rating)
  end
end
