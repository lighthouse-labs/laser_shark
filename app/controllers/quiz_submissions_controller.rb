class QuizSubmissionsController < ApplicationController

  before_action :require_quiz, only: [:new, :create]

  def new
    @quiz_submission = @quiz.quiz_submissions.new
  end

  def create
    result = CreateQuizSubmission.call(params: submission_params, user: current_user, quiz: @quiz)
    if result.success?
      @quiz_submission = result.quiz_submission
      if params[:activity_id].present?
        @activity = Activity.find params[:activity_id]
        if @activity.day?
          redirect_to day_activity_path(@activity.day, @activity)
        else
          redirect_to prep_activity_path(@activity.section, @activity)
        end
      else
        redirect_to quiz_submission_path(@quiz_submission.id, section_id: params[:section_id], day: params[:day])
      end
    else
      @quiz_submission = result.quiz_submission
      render :new
    end
  end

  def show
    @quiz_submission = current_user.quiz_submissions.find(params[:id])
    @quiz = @quiz_submission.quiz
  end

  private

  def submission_params
    params.require(:quiz_submission).permit(answers_attributes: [:option_id])
  end

  def require_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end
end
