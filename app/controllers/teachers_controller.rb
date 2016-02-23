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
    current_user.toggleOnDuty
    head :ok, content_type: "text/html"
  end

  protected

  def authorize_teacher
    permission_denied unless current_user.is_a?(Teacher)
  end

end
