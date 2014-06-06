class CommentsController < ApplicationController
  
  before_action :load_commentable

  def index
    @comments = @commentable.comments
  end

  def new
    @comment = @commentable.comments.new
  end

  def create

    @activity = Activity.chronological.for_day(day).find(params[:id])

    @comment = @commentable.comments.new(comment_params)
    if @comment.save
      redirect_to day_activity_path(@day, @activity), notice: "Comment created."
    else
      render :new
    end
  end 


private

  def load_commentable
    resource, id = request.path.split('/')[3,4]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

end
