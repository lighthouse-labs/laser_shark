class AssistanceChannel < ApplicationCable::Channel  

  def subscribed
    stream_from "assistance"
  end

  def start_assisting(data)
    ar = AssistanceRequest.find(data["request_id"])
    ar.start_assistance(current_user)

    ActionCable.server.broadcast "assistance", {
      type: "AssistanceStarted",
      object: AssistanceSerializer.new(ar.reload.assistance, root: false).as_json
    }

    UserChannel.broadcast_to ar.requestor, {type: "AssistanceStarted"}

  end

  def end_assistance(data)
    assistance = Assistance.find data["assistance_id"]
    ar = assistance.assistance_request
    ar.end_assistance(data["notes"])

    ActionCable.server.broadcast "assistance", {
      type: "AssistanceEnded",
      object: AssistanceSerializer.new(ar.reload.assistance, root: false).as_json
    }

    UserChannel.broadcast_to ar.requestor, {type: "AssistanceEnded"}
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
end