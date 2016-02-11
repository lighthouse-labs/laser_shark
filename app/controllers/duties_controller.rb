class DutiesController < ApplicationController

  def on_duty

    if current_user.is_a?(Teacher)

      current_user.update(on_duty: true)

      Pusher.trigger format_channel_name('TeacherChannel'),
                     'received', {
                        type: "TeacherOnDuty",
                        object: UserSerializer.new(current_user).as_json
                     }

      head :ok, content_type: "text/html"

    else

      permission_denied

    end
  end

  def off_duty

    if current_user.is_a?(Teacher)

      current_user.update(on_duty: false)

      Pusher.trigger format_channel_name('TeacherChannel'),
                     'received', {
                        type: "TeacherOffDuty",
                        object: UserSerializer.new(current_user).as_json
                     }

      head :ok, content_type: "text/html"

    else

      permission_denied

    end
  end
end