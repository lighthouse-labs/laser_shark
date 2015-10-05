class TeachersController < ApplicationController

  def index
    @teachers = Teacher.all
    @locations = Location.all.map(&:name)
  end

end
