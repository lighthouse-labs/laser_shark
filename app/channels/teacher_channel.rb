class TeacherChannel < ApplicationCable::Channel

  def subscribed
    stream_from channel_name
  end

  def on_duty
    if current_user.is_a?(Teacher)
      current_user.update(on_duty: true)
      ActionCable.server.broadcast channel_name, {
        type: "TeacherOnDuty",
        object: UserSerializer.new(current_user).as_json 
      }
    end
  end

  def off_duty
    if current_user.is_a?(Teacher)
      current_user.update(on_duty: false)
      ActionCable.server.broadcast channel_name, {
        type: "TeacherOffDuty",
        object: UserSerializer.new(current_user).as_json 
      }
    end
  end

  protected

  def channel_name
    location_name = current_user.is_a?(Student) ? current_user.cohort.location.name : current_user.location.name
    "teachers-#{location_name}"
  end

end