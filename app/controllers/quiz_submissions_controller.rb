class QuizSubmissionsController < ApplicationController
  def new
    @quiz = Quiz.find(params[:id])
    @quiz_submission = QuizSubmission.new(quiz: @quiz)
  end

  def create
    @quiz_submission = QuizSubmission.new(submission_params)
    @quiz_submission.user = current_user
    if @quiz_submission.save
      redirect_to quiz_submission_path @quiz_submission.id
    else
      render :new
    end
  end

  def show
    @quiz_submission = QuizSubmission.find(params[:id])
    @past_submissions = QuizSubmission.where("user_id = ? AND quiz_id = ? AND id != ?", current_user.id, @quiz_submission.quiz_id, @quiz_submission.id)
  end

  private
  def submission_params
    params.require(:quiz_submission).permit(:quiz_id, answers_attributes: [:option_id])
  end
end
