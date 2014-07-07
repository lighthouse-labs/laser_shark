class StudentsController < ApplicationController

  before_action :disallow_unless_enrolled

  def index
    @cohort   = Cohort.find(params[:cohort_id])
    @students = @cohort.students
  end

  private

  def disallow_unless_enrolled
    redirect_to(:root, alert: 'Not allowed') unless current_user && !current_user.prepping?
  end

end
