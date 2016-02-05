class Admin::OutcomesController < ApplicationController
  add_breadcrumb 'categories', :admin_categories_path
  add_breadcrumb 'skills', :admin_category_skills_path
  add_breadcrumb 'outcomes', :admin_category_skill_outcomes_path
  # add_breadcrumb 'activities', :admin_category_skill_outcome_activities_path

  before_action :require_outcome, only: [:show, :edit, :update, :destroy]

  def index
    @outcomes = Outcome.all
  end

  def edit
  end

  def create
    @skill = Skill.find params[:skill_id]
    @outcome = Outcome.new(outcome_params)
    if @outcome.save
      @skill.outcomes << @outcome
      redirect_to "/admin/categories/#{@skill.category.id}/skills/#{@skill.id}"
    else
      render :new
    end
  end

  def update
    if @outcome.update(outcome_params)
      redirect_to "/admin/categories/#{@outcome.skill.category.id}/skills/#{@outcome.skill.id}"
    else
      render :edit
    end
  end

  def destroy
    @outcome.destroy
    redirect_to "/admin/categories/#{@outcome.skill.category.id}/skills/#{@outcome.skill.id}"
  end

  def show
    @parent = @outcome
    @children = @outcome.activities
    @activities = Activity.all - @children
  end

  private
  def require_outcome
    @outcome = Outcome.find params[:id]
  end

  def outcome_params
    params.require(:outcome).permit(:text)
  end
end
