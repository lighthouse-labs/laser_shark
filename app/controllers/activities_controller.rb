class ActivitiesController < ApplicationController

  include CourseCalendar # concern

  def show
    @activity = Activity.chronological.for_day(day).find(params[:id])
    @commentable = @activity
    @comments = @commentable.comments.order('created_at ASC')
    @comment = Comment.new
    @current_user = current_user
  end

end
