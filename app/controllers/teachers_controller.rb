class TeachersController < ApplicationController

  before_action :load_teacher, except: [:index]

  def index
    @teachers = Teacher.all
    @locations = Location.all.order(:name).map(&:name)
  end

  def feedback
    @feedback = @teacher.feedbacks.find_or_create_by(student: current_user, feedbackable: nil)
    render 'feedbacks/modal_content', layout: false
  end

  def remove_mentorship
    if admin?
      @teacher.is_mentor = false
      @teacher.save!
    end
    render nothing: true
  end

  def add_mentorship
    if admin?
      @teacher.is_mentor = true
      @teacher.save!
    end
    render nothing: true
  end

  private

  def load_teacher
    @teacher = Teacher.find(params[:id])
  end

end
