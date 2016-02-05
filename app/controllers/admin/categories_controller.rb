class Admin::CategoriesController < ApplicationController
  add_breadcrumb 'categories', :admin_categories_path
  # add_breadcrumb 'skills', :admin_category_skills_path
  # add_breadcrumb 'outcomes', :admin_category_skill_outcomes_path
  # add_breadcrumb 'activities', :admin_category_skill_outcome_activities_path

  before_action :require_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to action: "index"
    else
      render :new
    end
  end

  def update
    if @category.update(category_params)
      redirect_to action: "index"
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
    redirect_to action: "index"
  end

  private
  def require_category
    @category = Category.find params[:id]
  end

  def category_params
    params.require(:category).permit(:text)
  end
end
