class Admin::ActivitiesController < ApplicationController

  before_action :load_parents
  before_action :require_activity, only: [:edit, :update, :destroy]

  def add_to_outcome
    @activity = Activity.find(activity_params[:id])
    @outcome.activities << @activity
    redirect_to [:admin, @category, @skill, @outcome]
  end

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
    filtered_params #{ids: filtered_params[:ids].tap {|e| e.delete ""}} # on account of a bug with collection_select, '' is always included
  end

  def filtered_params
    params.require(:activity).permit(:id)
  end
end