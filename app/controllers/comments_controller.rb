class CommentsController < ApplicationController
  
  before_action :load_commentable

  def index
    @comments = @commentable.comments
  end

  def new
    @comment = @commentable.comments.new
  end

  def create
    binding.pry
    @comment = @commentable.comments.new(params[:comment])
    if @comment.save
      redirect_to @commentable, notice: "Comment created."
    else
      render :new
    end
  end 


private

  def load_commentable
    resource, id = request.path.split('/')[3,4]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

end
