# class AssistanceChannel < ApplicationCable::Channel

#   def subscribed
#     stream_from "assistance-#{params[:location]}"
#   end

#   def start_assisting(data)
#     ar = AssistanceRequest.find(data["request_id"])
#     if ar.start_assistance(current_user)
#       ActionCable.server.broadcast "assistance-#{ar.requestor.cohort.location.name}", {
#         type: "AssistanceStarted",
#         object: AssistanceSerializer.new(ar.reload.assistance, root: false).as_json
#       }

#       UserChannel.broadcast_to ar.requestor, {type: "AssistanceStarted", object: UserSerializer.new(current_user).as_json}

#       teacher_busy(current_user)
#       update_students_in_queue(ar.requestor.cohort.location.name)
#     end

#   end

#   def end_assistance(data)
#     assistance = Assistance.find data["assistance_id"]
#     assistance.end(data["notes"], data["rating"].to_i)

#     ActionCable.server.broadcast "assistance-#{assistance.assistance_request.requestor.cohort.location.name}", {
#       type: "AssistanceEnded",
#       object: AssistanceSerializer.new(assistance, root: false).as_json
#     }

#     UserChannel.broadcast_to assistance.assistance_request.requestor, {type: "AssistanceEnded"}
#     teacher_available(current_user)

#   end

#   def cancel_assistance_request(data)
#     ar = AssistanceRequest.find data["request_id"]
#     if ar && ar.cancel
#       ActionCable.server.broadcast "assistance-#{ar.requestor.cohort.location.name}", {
#         type: "CancelAssistanceRequest",
#         object: AssistanceRequestSerializer.new(ar, root: false).as_json
#       }

#       UserChannel.broadcast_to ar.requestor, {type: "AssistanceEnded"}
#       update_students_in_queue(ar.requestor.cohort.location.name)
#     end
#   end

#   def stop_assisting(data)
#     assistance = Assistance.find data["assistance_id"]
#     if assistance && assistance.destroy
#       ActionCable.server.broadcast "assistance-#{assistance.assistance_request.requestor.cohort.location.name}", {
#         type: "StoppedAssisting",
#         object: AssistanceSerializer.new(assistance).as_json
#       }

#       teacher_available(current_user)
#       update_students_in_queue(assistance.assistance_request.requestor.cohort.location.name)
#     end
#   end

#   def provided_assistance(data)
#     student = Student.find data["student_id"]
#     assistance_request = AssistanceRequest.new(requestor: student, reason: "Offline assistance requested")
#     if assistance_request.save
#       assistance_request.start_assistance(current_user)
#       assistance = assistance_request.reload.assistance
#       assistance.end(data["notes"], data["rating"])

#       ActionCable.server.broadcast "assistance-#{assistance_request.requestor.cohort.location.name}", {
#         type: "OffineAssistanceCreated",
#         object: UserSerializer.new(student).as_json
#       }
#     end
#   end

# end