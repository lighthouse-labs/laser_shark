class TeachersController < ApplicationController

  def index
    @teachers = Teacher.all
    @locations = Location.where("id IN (?)", Cohort.all.map(&:location_id).uniq).map(&:name)
  end

end
