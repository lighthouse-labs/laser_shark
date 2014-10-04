class Admin::StudentsController < Admin::BaseController

  def index
    @students = Student.all
  end

  def change_cohort
    @student = Student.find(params[:student_id])
    @student.cohort = Cohort.find(params[:cohort_id])
    @student.save
    redirect_to :index, alert: "#{params.inspect}"
  end

  def remove_from_cohort
    @student = Student.find(params[:student_id])
    @cohort  = Cohort.find(params[:cohort_id])
    @cohort.students.delete(@student)
  end
end
