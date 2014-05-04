class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_student

  private

  def authenticate_student
    redirect_to new_session_path if !current_student
  end

  def current_student
    @current_student ||= Student.find_by_id(session[:student_id]) if session[:student_id]
  end
  helper_method :current_student

  def cohort
    @cohort ||= @current_student.cohort if @current_student
    @cohort ||= Cohort.last
  end

end
