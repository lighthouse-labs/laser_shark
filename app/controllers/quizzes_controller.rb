class QuizzesController < ApplicationController
  def show
    @quiz = Quiz.find(params[:id])
  end
end
