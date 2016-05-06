class CodeReviewsController < ApplicationController
  include CourseCalendar

  before_filter :teacher_required
  before_action :load_cohort
  # before_filter :load_student

  def index
    @students = @cohort.students
  end

  def show
    @code_review = Assistance.find(params[:id])
    render :show_modal, layout: false
  end

  def new
    @student = @cohort.students.find params[:student_id]
    @activity_submissions = @student.non_code_reviewed_activity_submissions
    @activities = @student.activities_grouped(today)
    @assistance = Assistance.new(assistor: current_user, assistee: @student)
    render :new_modal, layout: false
  end

  def create
    code_review_request = CodeReviewRequest.new(
      requestor_id: params[:assistance][:assistee_id],
      activity_id: params[:activity_id]
    )

    code_review_request.save!
    code_review_request.start_assistance(current_user)
    code_review = code_review_request.reload.assistance
    code_review.end(params[:assistance][:notes], params[:assistance][:rating].to_i, params[:assistance][:student_notes])

    redirect_to :back
  end

  private

  def teacher_required
    redirect_to(:root, alert: 'Not allowed') unless teacher?
  end

  def load_cohort
    @cohort = Cohort.find params[:cohort_id]
  end

  def load_student
    id = params["student_id"] || params["assistee-id"]
    puts "the id is: #{id}"
    @student = Student.find(id)
  end

end
