class Admin::OutcomesController < ApplicationController

  before_action :load_parents
  before_action :require_outcome, only: [:show, :edit, :update, :destroy, :autocomplete]

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
      redirect_to [:admin, @category, @skill]
    else
      render :edit
    end
  end

  def update
    if @outcome.update(outcome_params)
      redirect_to [:admin, @category, @skill]
    else
      render :edit
    end
  end

  def destroy
    @outcome.destroy
    redirect_to [:admin, @category, @skill]
  end

  def show
    @parent = @outcome
    @children = @outcome.activities
    @activities = (Activity.all - @outcome.activities).map do |activity|
      activity.name
    end.to_json
  end

  def autocomplete
    activities = (Activity.all - @outcome.activities).map do |activity|
      {
        id: activity.id,
        name: activity.name,
        value: (activity.name + ' ' + activity.day rescue activity.name),
        type: activity.type,
        day: activity.day,
      }
    end

    respond_to do |format|
      format.html
      format.json {
        render json: activities #.map {|e| e[:name] }.sort
      }
    end
  end

  private

  def load_parents
    @category = Category.find params[:category_id]
    @skill = @category.skills.find params[:skill_id]
  end

  def require_outcome
    @outcome = @skill.outcomes.find params[:id] || params[:outcome_id]
  end

  def outcome_params
    params.require(:outcome).permit(:text)
  end
end
