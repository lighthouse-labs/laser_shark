class TeachersController < ApplicationController

  def index
    @teachers = Teacher.all
    @locations = Location.all.map(&:name)
  end

  def show
    @teacher = Teacher.find(params[:id])
  end

end
