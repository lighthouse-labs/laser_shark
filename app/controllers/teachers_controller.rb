class TeachersController < ApplicationController

  before_action :authorize_teacher, only: :toggleDutyState

  def index
    @teachers = Teacher.all
    @locations = Location.all.order(:name).map(&:name)
  end

  def show
    @teacher = Teacher.find(params[:id])
  end

  def feedback
    @teacher = Teacher.find(params[:id])
    @feedback = @teacher.feedbacks.find_or_create_by(student: current_user, feedbackable: nil)
    render 'feedbacks/modal_content', layout: false
  end

  def toggleDutyState
    duty_status = !current_user.on_duty
    current_user.update!(on_duty: duty_status)

    Pusher.trigger(
      format_channel_name('TeacherChannel'), 
      "received",
      {
        type: duty_status ? "TeacherOnDuty" : "TeacherOffDuty",
        object: UserSerializer.new(current_user).as_json
      }
    )

    head :ok, content_type: "text/html"
  end

  protected

  def authorize_teacher
    permission_denied unless current_user.is_a?(Teacher)
  end

end
