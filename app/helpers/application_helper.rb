module ApplicationHelper
  # Display an integer time as a string
  # Ex: integer_time_to_s(930) # => "9:30"
  def integer_time_to_s(int_time)
    hours = int_time / 100
    minutes = int_time % 100
    minutes = "00" if minutes == 0
    return "#{hours}:#{minutes}"
  end
end
