class CohortsController < ApplicationController

  before_action :require_teacher

  def switch_to
    @cohort = Cohort.find params[:id]
    session[:cohort_id] = @cohort.id
    redirect_to day_path('today'), notice: "Switched to #{@cohort.name} cohort!"
  end

  def code_reviews
    @current_cohort = Cohort.find(params[:id])
    @students = @current_cohort.students
    @max_code_reviews_student = @students.max_by{|student| student.completed_code_review_requests.count}
  end 

  def code_review_modal_content
    render layout: false
  end

  protected

  def require_teacher
    redirect_to :root, alert: 'Only teachers can do this!' unless teacher?
  end

end
