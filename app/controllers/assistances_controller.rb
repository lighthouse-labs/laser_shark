class AssistancesController < ApplicationController

  before_filter :teacher_required

  # The creation of an Assistance is effected when
  #   1- The student made an AssistanceRequest
  #   2- TA presses the button `Start Assisting` for that same AssistanceRequest
  #
  def create
    data = assistances_params
    ar = AssistanceRequest.find(data["request_id"])

    # #start_assistance is responsible for Assistance#create
    if ar.start_assistance(current_user)
      location_name = ar.requestor.cohort.location.name
      Pusher.trigger format_channel_name("assistance", location_name),
                     "received", {
                        type: "AssistanceStarted",
                        object: AssistanceSerializer.new(ar.reload.assistance,
                                                         root: false).as_json
                      }

      Pusher.trigger format_channel_name("UserChannel", ar.requestor_id),
                     'received', {
                        type: "AssistanceStarted",
                        object: UserSerializer.new(current_user).as_json
                      }

      teacher_busy(current_user)
      update_students_in_queue(location_name)
      head :ok, content_type: "text/html"
    else
      permission_denied
    end
  end

  # After the Assistance has been #created, the TA will provide metrics regarding
  # the assistance rendered and submit them by pressing the `End Assistance` button.
  def finalize
    data = assistances_params
    assistance = Assistance.find data["id"]
    assistance.end(data["notes"], data["rating"].to_i)

    location_name = assistance.assistance_request.requestor.cohort.location.name
    Pusher.trigger format_channel_name("assistance", location_name),
                   "received", {
                     type: "AssistanceEnded",
                     object: AssistanceSerializer.new(assistance,
                                                      root: false).as_json
                   }

    requestor_id = assistance.assistance_request.requestor.id
    Pusher.trigger format_channel_name("UserChannel", requestor_id),
                   "received",
                   { type: "AssistanceEnded" }

    teacher_available(current_user)
    head :ok, content_type: "text/html"
  end

  # After Assistance has been #created, when TA presses button `Cancel Assisting`
  # #destroy gets called.
  def destroy
    data = assistances_params
    assistance = Assistance.find data["id"]
    if assistance && assistance.destroy
      location_name = assistance.assistance_request
                                .requestor
                                .cohort
                                .location
                                .name

      Pusher.trigger format_channel_name("assistance", location_name),
                     "received", {
                       type: "StoppedAssisting",
                       object: AssistanceSerializer.new(assistance).as_json
                     }

      teacher_available(current_user)
      update_students_in_queue(location_name)
      head :ok, content_type: "text/html"
    else
      permission_denied
    end
  end

  private

  def teacher_required
    redirect_to(:root, alert: 'Not allowed') unless teacher?
  end

  def assistances_params
    params.permit(:id, :request_id, :notes, :rating)
  end
end
