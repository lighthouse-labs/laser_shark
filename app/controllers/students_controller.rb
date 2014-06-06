class StudentsController < ApplicationController

  def index
    # @students = Student.where(cohort_id: params[:cohort_id]).all

    @cohort   = Cohort.find(params[:cohort_id])
    @students = @cohort.students
  end

end 