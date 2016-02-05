class Admin::CategoriesController < ApplicationController

  before_action :require_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to [:admin, :categories]
    else
      render :new
    end
  end

  def update
    if @category.update(category_params)
      redirect_to [:admin, :categories]
    else
      render :edit
    end
  end

  def show
    @parent = @category
    @children = @category.skills
  end

  def destroy
    @category.destroy
    redirect_to [:admin, :categories]
  end

  private

  def require_category
    @category = Category.find params[:id]
  end

  def category_params
    params.require(:category).permit(:text)
  end
end
