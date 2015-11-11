class AssistanceChannel < ApplicationCable::Channel  

  def subscribed
    stream_from "assistance"
  end

end