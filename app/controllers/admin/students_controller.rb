class Admin::StudentsController < Admin::BaseController

  def index
    @students = Student.all
  end

  def change_cohort
    @student = Student.find params[:student_id]
    @cohort  = Cohort.find params[:cohort_id]
    @student.cohort = @cohort
    @student.save
    redirect_to :back, alert: "#{@student.first_name} has been moved to #{@cohort.name}."
  end

  def remove_from_cohort
    @student = Student.find params[:student_id]
    @cohort  = @student.cohort
    @cohort.students.delete(@student)
    redirect_to :back, alert: "#{@student.first_name} has been removed from #{@cohort.name}."
  end
end
