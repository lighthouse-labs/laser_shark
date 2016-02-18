class CodeReviewRequest < AssistanceRequest

  after_create :send_create_websocket_messages

  protected

  def send_create_websocket_messages
    # => Send the code review to all teachers
    Pusher.trigger(
      SocketService.get_formatted_channel_name("assistance", self.requestor.location.name),
      'received',
      {
        type: "CodeReviewRequest",
        object: CodeReviewSerializer.new(self, root: false).as_json
      }
    )
  end

end
