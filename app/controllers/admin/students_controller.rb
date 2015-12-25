class Admin::StudentsController < Admin::BaseController
  before_action :load_student, except: [:index]
  before_action :load_cohort, only: [:index]

  def index
    redirect_to admin_cohorts_path, notice: 'Must select a cohort' unless params[:cohort_id]
    @students = @current_cohort.students
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
    @student.update(student_params)
    redirect_to :back if @student.save
  end

  def modal_content
    @cohorts = Cohort.is_active
    @mentors = Teacher.mentors(@student.cohort.location)
    render layout: false
  end

  private

  def load_student
    @student = Student.find(params[:id])
  end

  def load_cohort
    @current_cohort = Cohort.find(params[:cohort_id])
  end

  def student_params
    params.require(:student).permit(
      :mentor_id,
      :cohort_id
    )
  end
end
