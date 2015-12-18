class SearchActivitiesController < ApplicationController

  def index
    if params[:query].blank?
      @activities = []
      flash[:alert] = 'Please enter a search term'
    else
      @activities = Activity.search(params[:query]).where("day <= ?", CurriculumDay.new(Date.today, cohort).to_s).order(:day).reverse
    end
  end

end