module Notifications
  module AssistanceNotifications
    extend ActiveSupport::Concern

    included do
    
      after_create :send_create_socket_messages
      after_destroy :send_destroy_socket_messages
    
      def send_notes_to_slack
        post_to_slack(ENV['SLACK_CHANNEL'])
        post_to_slack(ENV['SLACK_CHANNEL_REMOTE']) if self.assistee.remote
      end

      def post_to_slack(channel)
        return if ENV['SLACK_TOKEN'].nil? || channel.nil?
        options = {
          username: self.assistor.github_username,
          icon_url: self.assistor.avatar_url,
          channel: channel
        }
        begin
          poster = Slack::Poster.new('lighthouse', ENV['SLACK_TOKEN'], options)
          poster.send_message("*Assisted #{self.assistee.full_name} for #{ ((self.end_at - self.start_at)/60).to_i } minutes*:\n #{self.notes}")
        rescue
        end
      end

      def send_create_socket_messages
        if self.assistance_request
          location_name = self.assistee.cohort.location.name
          
          Pusher.trigger(
            SocketService.get_formatted_channel_name("assistance", location_name),
            "received", {
              type: "AssistanceStarted",
              object: AssistanceSerializer.new(self, root: false).as_json
            }
          )

          self.assistor.send_web_socket_busy
          Student.send_queue_update_in_location(location_name)

          Pusher.trigger(
            SocketService.get_formatted_channel_name("UserChannel", self.assistee_id),
            'received', {
              type: "AssistanceStarted",
              object: UserSerializer.new(self.assistor).as_json
            }
          )
        end
      end

      def send_destroy_socket_messages
        location_name = self.assistee.cohort.location.name

        Pusher.trigger(
          SocketService.get_formatted_channel_name("assistance", location_name),
          "received", {
            type: "StoppedAssisting",
            object: AssistanceSerializer.new(self).as_json
          }
        )

        self.assistor.send_web_socket_available
        Student.send_queue_update_in_location(location_name)
      end

      def send_assistance_ended_socket_messages
        location_name = self.assistee.cohort.location.name
        
        Pusher.trigger(
          SocketService.get_formatted_channel_name("assistance", location_name),
          "received", {
            type: "AssistanceEnded",
            object: AssistanceSerializer.new(self, root: false).as_json
          }
        )
        
        Pusher.trigger(
          SocketService.get_formatted_channel_name("UserChannel", self.assistee_id),
           "received",
          { type: "AssistanceEnded" }
        )

        self.assistor.send_web_socket_available
      end
      
    end
  end
end