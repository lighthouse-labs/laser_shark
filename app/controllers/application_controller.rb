class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user

  private

  def authenticate_user
    if !current_user
      session[:attempted_url] = request.url
      redirect_to new_session_path, alert: 'Please login first!' 
    elsif current_user.deactivated?
      session[:user_id] = nil
      redirect_to :root, alert: 'Your account has been deactivated. Please contact the admin if this is in error.'
    end
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def teacher?
    current_user && current_user.is_a?(Teacher)
  end
  helper_method :teacher?

  def student?
    current_user && current_user.is_a?(Student)
  end
  helper_method :student?

  def admin?
    current_user && current_user.is_a?(Admin)
  end
  helper_method :admin?
  
  def active_student?
    student? && current_user.active_student?
  end
  helper_method :active_student?

  def alumni?
    student? && current_user.alumni?
  end
  helper_method :alumni?

  def cohort
    @cohort ||= current_user.try(:cohort)
    # Teachers can switch to any cohort
    if teacher?
      @cohort ||= Cohort.find_by(id: session[:cohort_id]) if session[:cohort_id]
    end
    @cohort ||= Cohort.most_recent.first
  end
  helper_method :cohort

  def cohorts
    @cohorts ||= Cohort.order(start_date: :asc)
  end
  helper_method :cohorts

  def assign_cohort(invitation_code)
    current_user.cohort = Cohort.find_by(code: invitation_code)
    current_user.type = "Student"
    current_user.save
  end

end
