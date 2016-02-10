class DutiesController < ApplicationController

  def on_duty
    if current_user.is_a?(Teacher)
      current_user.update(on_duty: true)

      Pusher.trigger 'TeacherChannel', 'received', {
        type: "TeacherOnDuty",
        object: UserSerializer.new(current_user).as_json
      }
    end
    head :ok, content_type: "text/html"
  end

  def off_duty
    if current_user.is_a?(Teacher)
      current_user.update(on_duty: false)

      Pusher.trigger 'TeacherChannel', 'received', {
        type: "TeacherOffDuty",
        object: UserSerializer.new(current_user).as_json
      }
    end
    head :ok, content_type: "text/html"
  end
end