class ActivitiesController < ApplicationController

  include CourseCalendar # concern

  def show
    @activity = Activity.chronological.for_day(day).find(params[:id])

  end

  def search
    # Search by exact single type only
		# @activities = search_activities(params[:query])

    @activities = Activity.search(params[:query])
    
  end

  #helper_method :search

	def search_activities(q)


		Activity.where('type LIKE ?', q)


	end

end
