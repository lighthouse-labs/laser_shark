class TeachersController < ApplicationController

  def index
    @teachers = User.where(type: "Teacher", deactivated_at: nil)
  end
  
end