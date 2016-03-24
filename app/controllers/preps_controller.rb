class PrepsController < ApplicationController

  def show
    @prep = Prep.find_by(slug: params[:id])
    @activities = @prep.activities.chronological
  end

end