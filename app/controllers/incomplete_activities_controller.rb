class IncompleteActivitiesController < ApplicationController

  before_filter :student_required

  def index
    @activities = current_user.incomplete_activities
  end

  private

  def student_required
    redirect_to(:root, alert: 'Not allowed') unless student?
  end

end