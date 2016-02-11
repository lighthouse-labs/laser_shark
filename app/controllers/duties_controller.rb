class DutiesController < ApplicationController

  def toggleDutyState

    if current_user.is_a?(Teacher)

      duty_status = !current_user.on_duty
      current_user.update!(on_duty: duty_status)

      Pusher.trigger format_channel_name('TeacherChannel'),
                     'received', {
                        type: duty_status ? "TeacherOnDuty" : "TeacherOffDuty",
                        object: UserSerializer.new(current_user).as_json
                     }

      head :ok, content_type: "text/html"

    else

      permission_denied

    end
  end

end