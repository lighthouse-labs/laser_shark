class StudentsController < ApplicationController

  def index

    @cohort   = Cohort.find(params[:cohort_id])
    @students = @cohort.students
    
  end

end 