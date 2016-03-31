class QuizSubmissionsController < ApplicationController
  def new
    @quiz = Quiz.find(params[:id])
    @quiz_submission = QuizSubmission.new(quiz: @quiz)
  end

  def create
    quiz_submission = QuizSubmission.new(params[:quiz_submission])
    quiz_submission.save
  end

  def show
  end

end
