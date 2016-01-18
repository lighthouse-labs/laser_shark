class StudentsController < ApplicationController

  before_action :disallow_unless_enrolled
  before_action :teacher_required, only: [:show, :new_code_review_modal]
  Activities_ = Struct.new(:id, :name)

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
  end

  def new_code_review_modal
    @student = Student.find(params[:id])
    @activity_submissions = @student.activity_submissions.order(created_at: :desc).with_github_url.map{|e| Activities_.new(e.id,e.activity.name) }
    @assistance = Assistance.new(assistor: current_user, assistee: @student)
    render layout: false
  end

  private

  def disallow_unless_enrolled
    redirect_to(:root, alert: 'Not allowed') unless current_user && !current_user.prepping?
  end

  def teacher_required
    redirect_to(:root, alert: 'Not allowed') unless teacher?
  end

end
