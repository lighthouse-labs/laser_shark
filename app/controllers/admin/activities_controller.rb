class Admin::ActivitiesController < ApplicationController

  before_action :load_parents
  before_action :require_activity, only: [:edit, :update, :destroy]

  def index
    @activities = Activity.all
  end

  # def edit
  # end

  def create
    @activities = Activity.find(activity_params[:ids])
    @outcome.activities += @activities
    redirect_to [:admin, @category, @skill, @outcome]
  end

  # def update
  #   if @activity.update(activity_params)
  #     redirect_to [:admin, @category, @skill, @outcome]
  #   else
  #     render :edit
  #   end
  # end

  def destroy
    @outcome.activities.delete(@activity)
    redirect_to [:admin, @category, @skill, @outcome]
  end

  private

  def load_parents
    @category = Category.find params[:category_id]
    @skill = @category.skills.find params[:skill_id]
    @outcome = @skill.outcomes.find params[:outcome_id]
  end

  def require_activity
    @activity = @outcome.activities.find params[:id]
  end

  def activity_params
    {ids: filtered_params[:ids].tap {|e| e.delete ""}}
  end

  def filtered_params
    params.require(:activity).permit(:ids => [])
  end
end