class QuizSubmissionsController < ApplicationController

  before_action :require_quiz, only: [:new, :create]

  def new
    @quiz_submission = @quiz.quiz_submissions.new
  end

  def create
    result = CreateQuizSubmission.call(params: submission_params, user: current_user, quiz: @quiz)
    if result.success?
      @quiz_submission = result.quiz_submission
      redirect_to quiz_submission_path @quiz_submission.id
    else
      @quiz_submission = result.quiz_submission
      render :new
    end
  end

  def show
    @quiz_submission = QuizSubmission.find(params[:id])
    @past_submissions = QuizSubmission.where("user_id = ? AND quiz_id = ? AND id != ?", current_user.id, @quiz_submission.quiz_id, @quiz_submission.id)
  end

  private

  def submission_params
    params.require(:quiz_submission).permit(answers_attributes: [:option_id])
  end

  def require_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end
end
