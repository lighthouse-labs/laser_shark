class UserChannel < ApplicationCable::Channel

  def subscribed
    stream_for current_user
  end

  def request_assistance(data)
    ar = AssistanceRequest.new(:requestor => current_user, reason: data["reason"])
    ar.save

    ActionCable.server.broadcast "assistance", {
      type: "AssistanceRequest",
      object: AssistanceRequestSerializer.new(ar, root: false).as_json
    }
  end

  def cancel_assistance
    ar = current_user.assistance_requests.where(type: nil).open_or_in_progress_requests.newest_requests_first.first
    if ar && ar.cancel
      ActionCable.server.broadcast "assistance", {
        type: "CancelAssistanceRequest",
        object: AssistanceRequestSerializer.new(ar, root: false).as_json
      }
    end
  end

end