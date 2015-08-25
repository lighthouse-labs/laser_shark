class AbsentsController < ApplicationController
  
  include CourseCalendar # concern

  before_action :require_teacher

  def create
    # TODO - Day changes at 6pm? so 'today' on a fri night converts to weekend ex w-1e
    @formatted_date = CurriculumDay.new(params[:day_number], cohort).to_s
    @students = cohort.students
    @students.each do |student|
      if params[:student_ids] && params[:student_ids].include?("#{student.id}")
        @absent = Absent.find_or_create_by(student_id: student.id, date: @formatted_date)
      else 
        @absent = Absent.destroy_all(student_id: student.id, date: @formatted_date)
      end
    end

    redirect_to day_path(params[:day_number]), notice: 'Attendance taken!'
  end

  def index
    @absent = Absent.new
    @students = cohort.students

    @status = @students.collect{|student| student.absent?(params[:day_number])}

    @attendance = true
  end
  
  private
  
  def absent_params
    params.require(:absent).permit(
      :student_ids
    )
  end

  protected

  # TODO - access from somewhere else?
  def require_teacher
    redirect_to :root, alert: 'Only teachers can do this!' unless teacher?
  end

end