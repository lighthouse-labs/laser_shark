class StudentsController < ApplicationController

  before_action :disallow_unless_enrolled

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

end
