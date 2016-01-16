class Admin::StudentsController < Admin::BaseController
  before_action :load_student, only: [:reactivate, :deactivate, :update, :edit]

  def index
    if params[:cohort_id]
      @current_cohort = Cohort.find(params[:cohort_id])
      @students = @current_cohort.students
    else
      @students = Student.all
    end
    @cohorts = Cohort.is_active
  end

  def edit
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
    if @student.update(student_params)
      redirect_to [:edit, :admin, @student], notice: 'Updated!'
    else
      render :edit
    end    
  end

  private

  def student_params
    params.require(:student).permit(
      :first_name,
      :last_name,
      :email,
      :github_username,
      :type,
      :unlocked_until_day,
      :cohort_id
    )

  end

  def load_student
    @student = Student.find(params[:id])
  end
end
