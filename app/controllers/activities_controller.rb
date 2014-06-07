class ActivitiesController < ApplicationController

  include CourseCalendar # concern

  def show
    @activity = Activity.chronological.for_day(day).find(params[:id])
    @next_activity = @activity.next
    @previous_activity = @activity.previous
    @commentable = @activity
    @comments = @commentable.comments.order('created_at ASC')
    @comment = Comment.new
  end

end
