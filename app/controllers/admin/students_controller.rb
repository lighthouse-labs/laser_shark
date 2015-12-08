class Admin::StudentsController < Admin::BaseController
  before_action :load_student, only: [:reactivate, :deactivate, :update]

  def index
    if params[:cohort_id]
      @current_cohort = Cohort.find(params[:cohort_id])
      @students = @current_cohort.students
    else
      @students = Student.all
    end
    @cohorts = Cohort.is_active
  end

  def reactivate
    @student.reactivate
    render nothing: true if @student.save
  end

  def deactivate
    @student.deactivate
    render nothing: true if @student.save
  end

  def update
    @cohort = Cohort.find(params[:cohort_id])
    @student.update(cohort: @cohort)
    render nothing: true if @student.save
  end

  private

  def load_student
    @student = Student.find(params[:id])
  end
end
