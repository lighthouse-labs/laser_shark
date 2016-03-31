class QuizSubmissionsController < ApplicationController
  def new
    @quiz = Quiz.find(params[:id])
    @quiz_submission = QuizSubmission.new(quiz: @quiz)
  end

  def create
    @quiz_submission = QuizSubmission.new(submission_params)
    @quiz_submission.user = current_user
    if @quiz_submission.save
      render :show
    else
      render :new
    end
  end

  def show
  end

  private
  def submission_params
    params.require(:quiz_submission).permit(:quiz_id, answers_attributes: [:option_id])
  end
end
