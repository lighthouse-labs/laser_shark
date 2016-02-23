class SocketService

  def self.get_formatted_channel_name(channel, id = '')
    s = [ENV['APP_NAME'], channel, id.to_s].join('-')
  end
  
end