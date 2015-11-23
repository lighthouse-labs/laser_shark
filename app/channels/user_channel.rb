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

    UserChannel.broadcast_to current_user, {type: "AssistanceRequested"}
  end

  def cancel_assistance
    ar = current_user.assistance_requests.where(type: nil).open_or_in_progress_requests.newest_requests_first.first
    if ar && ar.cancel
      ActionCable.server.broadcast "assistance", {
        type: "CancelAssistanceRequest",
        object: AssistanceRequestSerializer.new(ar, root: false).as_json
      }

      UserChannel.broadcast_to current_user, {type: "AssistanceCancelled"}
    end
  end

  def on_duty
    if current_user.is_a?(Teacher)
      current_user.update(on_duty: true)
      send_to_all_in_location({
        type: "TeacherOnDuty",
        object: UserSerializer.new(current_user).as_json 
      })
      
    end
  end

  def off_duty
    if current_user.is_a?(Teacher)
      current_user.update(on_duty: false)
      send_to_all_in_location({
        type: "TeacherOffDuty",
        object: UserSerializer.new(current_user).as_json 
      })
    end
  end

  protected

  def send_to_all_in_location(message)
    users = User
      .includes(cohort: :location)
      .where(
        User
          .cohort_in_locations([current_user.location.name])
          .where(location: current_user.location)
          .where_values.reduce(:or)
      ).references(:cohort, :location)

    users.each do |user|
      UserChannel.broadcast_to user, message
    end
  end


end