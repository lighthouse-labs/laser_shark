class SearchActivitiesController < ApplicationController

  before_action :query_required

  def index
    @activities = Activity.search(params[:query]).where("day <= ?", CurriculumDay.new(Date.today, cohort).to_s).order(:day).reverse
  end

  private

  def query_required
    redirect_to(:root, alert: 'Please enter a search term') unless params[:query]
  end

end