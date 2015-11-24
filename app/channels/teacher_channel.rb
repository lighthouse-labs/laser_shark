class TeacherChannel < ApplicationCable::Channel

  def subscribed
    stream_from "teachers"

    # teachers = Teacher.where(on_duty: true)
    # ActionCable.server.broadcast "teachers", {
    #   type: "UserConnected",
    #   object: teachers.collect{|teacher| UserSerializer.new(teacher).as_json}
    # }
  end

  def on_duty
    if current_user.is_a?(Teacher)
      current_user.update(on_duty: true)
      ActionCable.server.broadcast "teachers", {
        type: "TeacherOnDuty",
        object: UserSerializer.new(current_user).as_json 
      }
    end
  end

  def off_duty
    if current_user.is_a?(Teacher)
      current_user.update(on_duty: false)
      ActionCable.server.broadcast "teachers", {
        type: "TeacherOffDuty",
        object: UserSerializer.new(current_user).as_json 
      }
    end
  end

end