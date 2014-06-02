class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user

  private

  def authenticate_user
    redirect_to new_session_path, alert: 'Please login first!' unless current_user
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def teacher?
    current_user && current_user.is_a?(Teacher)
  end
  helper_method :teacher?

  def cohort
    @cohort ||= current_user.try(:cohort)
    # Teachers can switch to any cohort
    if teacher?
      @cohort ||= Cohort.find session[:cohort_id] if session[:cohort_id]
    end
    @cohort ||= Cohort.most_recent.first
  end
  helper_method :cohort

  def cohorts
    @cohorts ||= Cohort.all
  end
  helper_method :cohorts

end
