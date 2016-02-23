module Notifications
  module AssistanceRequestNotifications
    extend ActiveSupport::Concern

    included do
      after_create :send_create_socket_messages

      def send_create_socket_messages
        location_name = self.requestor.cohort.location.name
        serialized_ar = AssistanceRequestSerializer.new(self, root: false).as_json

        Pusher.trigger(
          SocketService.get_formatted_channel_name("assistance", location_name),
          'received', {
           type: "AssistanceRequest",
           object: serialized_ar
          }
        )

        Pusher.trigger(
          SocketService.get_formatted_channel_name("UserChannel", self.requestor.id),
          'received', {
            type: 'AssistanceRequested',
            object: self.requestor.position_in_queue
          }
        )
      end

      def send_destroy_socket_messages
        location_name = self.requestor.cohort.location.name
        serialized_ar = AssistanceRequestSerializer.new(self, root: false).as_json

        Pusher.trigger(
          SocketService.get_formatted_channel_name("assistance", location_name),
          "received", {
            type: "CancelAssistanceRequest",
            object: serialized_ar
          }
        )

        Pusher.trigger(
          SocketService.get_formatted_channel_name("UserChannel", self.requestor_id),
          'received',
          { type: "AssistanceEnded" }
        )

        Student.send_queue_update_in_location(location_name)

        # In case scenario -2 applies, make TA available again.
        self.assistance.assistor.send_web_socket_available if self.assistance
      end
    end
  end
end