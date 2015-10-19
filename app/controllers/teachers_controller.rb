class TeachersController < ApplicationController

  def index
    @teachers = Teacher.all
    @locations = Location.all.map(&:name)
  end

  def show
    @teacher = Teacher.find(params[:id])
  end

  def feedback
    @teacher = Teacher.find(params[:id])
    # @feedback = Feedback.new(teacher: @teacher, student: current_user, feedbackable: 'Activity')
    render layout: false
  end

end
