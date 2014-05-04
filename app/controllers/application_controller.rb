class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user

  private

  def authenticate_user
    redirect_to github_session_path if !current_user
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def cohort
    @cohort ||= @current_user.cohort if current_user
    @cohort ||= Cohort.last
  end

end
