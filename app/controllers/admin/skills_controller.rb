class Admin::SkillsController < ApplicationController
  add_breadcrumb 'categories', :admin_categories_path
  add_breadcrumb 'skills', :admin_category_skills_path
  # add_breadcrumb 'outcomes', :admin_category_skill_outcomes_path
  # add_breadcrumb 'activities', :admin_category_skill_outcome_activities_path

  before_action :require_skill, only: [:show, :edit, :update, :destroy]

  def index
    @skills = Skill.all
  end

  def edit
  end

  def create
    @category = Category.find params[:category_id]
    @skill = Skill.new(skill_params)
    if @skill.save
      @category.skills << @skill
      redirect_to "/admin/categories/#{@category.id}"
    else
      render :nothing => true, :status => 400
    end
  end

  def update
    if @skill.update(skill_params)
      redirect_to "/admin/categories/#{@skill.category.id}"
    else
      render :nothing => true, :status => 400
    end
  end

  def show
    @parent = @skill
    @children = @skill.outcomes
  end

  def destroy
    @skill.destroy
    redirect_to "/admin/categories/#{@skill.category.id}"
  end

  private
  def require_skill
    @skill = Skill.find params[:id]
  end

  def skill_params
    params.require(:skill).permit(:text)
  end
end