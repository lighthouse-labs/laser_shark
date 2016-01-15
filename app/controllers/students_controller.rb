class StudentsController < ApplicationController

  before_action :disallow_unless_enrolled
  before_action :teacher_required, only: [:show]

  def index
    if teacher?
      @cohort = Cohort.find(params[:cohort_id])
    else
      @cohort = current_user.cohort
    end
    @students = @cohort.students.active
  end

  def show
    @student = Student.find(params[:id])
    @code_reviews = @student.completed_code_review_requests
    @assistance_requests = @student.completed_assistance_requests
    @assistance_requests_count = @assistance_requests.count
    @assistance_requests = @assistance_requests.last(10).reverse
    @activity_submissions = @student.activity_submissions.requires_code_submission
    @assistance = Assistance.new(assistor: current_user, assistee: @student)
  end

  def new_assistance_modal
    @assistance = Assistance.new(assistor: current_user, assistee: @student)
  end

  private

  def disallow_unless_enrolled
    redirect_to(:root, alert: 'Not allowed') unless current_user && !current_user.prepping?
  end

  def teacher_required
    redirect_to(:root, alert: 'Not allowed') unless teacher?
  end

end
