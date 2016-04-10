class StudentsController < ApplicationController

  before_action :disallow_unless_enrolled
  before_action :teacher_required, only: [:show, :new_code_review_modal]
  before_action :load_student, only: [:show, :new_code_review_modal]

  def index
    if teacher?
      @cohort = Cohort.find(params[:cohort_id])
    else
      @cohort = current_user.cohort
    end
    @students = @cohort.students.active
  end

  private

  def disallow_unless_enrolled
    redirect_to(:root, alert: 'Not allowed') unless current_user && !current_user.prepping?
  end

  def teacher_required
    redirect_to(:root, alert: 'Not allowed') unless teacher?
  end

  def load_student
    @student = Student.find(params[:id])
  end

end
