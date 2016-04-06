class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :add_question, :link_question]
  def new
    @quiz = Quiz.create
    redirect_to "/quizzes/#{@quiz.id}/add_question"
  end
  def show
    @submission_stats = @quiz.quiz_submissions.stats
    @question_stats = @quiz.questions.stats(@quiz)

  end
  def add_question
    @questions = Question.all
  end
  def link_question
    @quiz.questions << Question.find(params[:question][:id])
    if @quiz.save
      redirect_to "/quizzes/#{@quiz.id}/add_question" if params[:add] == "add"
      redirect_to quiz_path(@quiz.id) if params[:add] == "save"
    else
    end
  end

  private
  def set_quiz
    @quiz = params[:id] && params[:id] != "add_question" ? Quiz.find(params[:id]) : Quiz.find(params[:quiz_id])
  end
end
