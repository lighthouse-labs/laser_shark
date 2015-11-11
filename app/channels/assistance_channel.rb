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

end