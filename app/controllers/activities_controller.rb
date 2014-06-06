class ActivitiesController < ApplicationController

  include CourseCalendar # concern

  def show
    @activity = Activity.chronological.for_day(day).find(params[:id])
  end

  def search
		@activities = search_activities(params[:query])

	end

	def search_activities(q)

		Activity.where('type LIKE ?', q).to_sql

	end

end
