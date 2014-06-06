module ApplicationHelper
  # Display an integer time as a string
  # Ex: integer_time_to_s(930) # => "9:30"
  def integer_time_to_s(int_time)
    hours = int_time / 100
    minutes = int_time % 100
    minutes = "00" if minutes == 0
    return "#{hours}:#{minutes}"
  end


  def avatar_for(user)
    if user.custom_avatar.url
      user.custom_avatar.url(:thumb)
    else
      user.avatar_url
    end
  end

  def format_date_time(time)
    time.strftime("%b %e, %l:%M %p")
  end

end
