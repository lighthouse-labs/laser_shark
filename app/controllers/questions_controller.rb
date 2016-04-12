class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :teacher_required

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = Question.new
    @outcomes = Outcome.all
    2.times { @question.options << Option.new }
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to @question, notice: "Question #{@question.id} was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @question.update question_params
      redirect_to @question, notice: "Question #{@question.id} was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:question, :outcome_id, options_attributes: [:id, :answer, :explanation, :correct, :_destroy])
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def teacher_required
    redirect_to day_path('today'), alert: 'Not allowed' unless teacher?
  end
end
