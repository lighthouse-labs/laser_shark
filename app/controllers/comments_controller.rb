class CommentsController < ApplicationController
  
  before_action :load_commentable

  def create

    @activity = Activity.find(params[:activity_id])
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id
    
    if @comment.save
      redirect_to day_activity_path(@activity.day, @activity), notice: "Comment created."
    else
      render :new
    end
  end 


private

  def load_commentable
    resource, id = request.path.split('/')[1,2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  def comment_params
    params.require(:comment).permit(:content, :user_id)
  end

end
