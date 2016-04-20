class PrepsController < ApplicationController

  def show
    @prep = Prep.find_by(slug: params[:id])
    @activities = @prep.activities.chronological
  end

  def index
    @prep = Prep.first
    @activity = @prep.activities.first

    redirect_to prep_activity_path(@prep, @activity)
  end

end