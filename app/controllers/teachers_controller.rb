class TeachersController < ApplicationController

  def index
    @teachers = Teacher.all
    @locations = Location.select(:name).map(&:name).uniq
  end

end
