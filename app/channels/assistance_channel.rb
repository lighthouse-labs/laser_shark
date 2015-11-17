class AssistanceChannel < ApplicationCable::Channel  

  def subscribed
    stream_from "assistance"
  end

  def start_assisting(data)
    ar = AssistanceRequest.find(data["request_id"])
    if ar.start_assistance(current_user)
      ActionCable.server.broadcast "assistance", {
        type: "AssistanceStarted",
        object: AssistanceSerializer.new(ar.reload.assistance, root: false).as_json
      }

      UserChannel.broadcast_to ar.requestor, {type: "AssistanceStarted"}
    end

  end

  def end_assistance(data)
    assistance = Assistance.find data["assistance_id"]
    assistance.end(data["notes"], data["rating"].to_i)

    ActionCable.server.broadcast "assistance", {
      type: "AssistanceEnded",
      object: AssistanceSerializer.new(assistance, root: false).as_json
    }

    UserChannel.broadcast_to assistance.assistance_request.requestor, {type: "AssistanceEnded"}
  end

  def cancel_assistance_request(data)
    ar = AssistanceRequest.find data["request_id"]
    if ar && ar.cancel
      ActionCable.server.broadcast "assistance", {
        type: "CancelAssistanceRequest",
        object: AssistanceRequestSerializer.new(ar, root: false).as_json
      }

      UserChannel.broadcast_to ar.requestor, {type: "AssistanceCancelled"}
    end
  end

  def stop_assisting(data)
    assistance = Assistance.find data["assistance_id"]
    if assistance && assistance.destroy
      ActionCable.server.broadcast "assistance", {
        type: "StoppedAssisting",
        object: AssistanceSerializer.new(assistance).as_json
      }

      UserChannel.broadcast_to assistance.assistee, {type: "AssistanceCancelled"}
    end
  end

  def provided_assistance(data)
    student = Student.find data["student_id"]
    assistance_request = AssistanceRequest.create(requestor: student, reason: "Offline assistance requested")
    assistance_request.start_assistance(current_user)
    assistance = assistance_request.reload.assistance

    assistance.end(data["notes"], data["rating"])
    ActionCable.server.broadcast "assistance", {
      type: "OffineAssistanceCreated",
      object: UserSerializer.new(student).as_json
    }
  end
end