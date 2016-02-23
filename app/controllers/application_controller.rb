class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user
  before_action :set_timezone
  before_filter :set_raven_context

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

  def set_raven_context
    if current_user
      Raven.user_context({
        'id' => current_user.id,
        'email' => current_user.email
      })
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

  def active_student?
    student? && current_user.active_student?
  end
  helper_method :active_student?

  def alumni?
    student? && current_user.alumni?
  end
  helper_method :alumni?

  def admin?
    current_user.try :admin?
  end
  helper_method :admin?

  def teachers_on_duty
    return [] if current_user && !current_user.is_a?(Teacher) && !current_user.is_a?(Student)

    if current_user
      location = current_user.location
      location = current_user.cohort.location if current_user.is_a?(Student)
      Teacher.where(on_duty: true, location: location)
    else
      []
    end
  end
  helper_method :teachers_on_duty

  def cohort
    # Teachers can switch to any cohort
    if teacher?
      @cohort ||= Cohort.find_by(id: session[:cohort_id]) if session[:cohort_id]
    end
    @cohort ||= current_user.try(:cohort) # Students have a cohort
    @cohort ||= Cohort.most_recent.first # If any cohorts exist, use the latest
    @program = @cohort.try(:program)
    @cohort
  end
  helper_method :cohort

  def cohorts
    @cohorts ||= Cohort.order(start_date: :desc)
  end
  helper_method :cohorts

  def dropdown_cohorts
    @dropdown_cohorts ||= Cohort.order(start_date: :desc).starts_between(Date.current - 2.months, Date.current + 2.weeks)
  end
  helper_method :dropdown_cohorts

  def streams
    @streams ||= Stream.order(:title)
  end
  helper_method :streams

  def pending_feedbacks
    current_user.feedbacks.pending.reverse_chronological_order.where.not(feedbackable: nil).not_expired
  end
  helper_method :pending_feedbacks

  def assign_as_student_to_cohort(cohort)
    current_user.cohort = cohort
    current_user.type = 'Student'
    current_user.save!
    flash[:notice] = "Welcome, you have student access to #{cohort.name}!"
  end

  def apply_invitation_code(code)
    if ENV['TEACHER_INVITE_CODE'] == code
      make_teacher
    elsif cohort = Cohort.find_by(code: code)
      assign_as_student_to_cohort(cohort)
    else
      flash[:alert] = "Sorry, invalid code"
    end
  end

  def make_teacher
    unless teacher?
      current_user.type = 'Teacher'
      current_user.save!
      AdminMailer.new_teacher_joined(current_user).deliver
      flash[:notice] = "Welcome, you have teacher access!"
    end
  end

  def set_timezone
    if cohort
      case cohort.location.name
      when 'Vancouver'
        Time.zone = 'Pacific Time (US & Canada)'
      when 'Toronto'
        Time.zone = 'Eastern Time (US & Canada)'
      when 'Calgary'
        Time.zone = 'Mountain Time (US & Canada)'
      end
    end
  end

end
