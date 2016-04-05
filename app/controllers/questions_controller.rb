class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = Question.new
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
  end

  def destroy
  end

  private

  def question_params
    params.require(:question).permit(:question, options_attributes: [:id, :answer, :explanation, :correct, :_destroy])
  end
end
