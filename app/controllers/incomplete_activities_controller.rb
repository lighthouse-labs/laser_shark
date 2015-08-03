class IncompleteActivitiesController < ApplicationController

  def index
    @activities = current_user.incomplete_activities
  end

end
