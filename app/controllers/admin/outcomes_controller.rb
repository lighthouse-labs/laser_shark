class Admin::OutcomesController < ApplicationController

  before_action :load_parents
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
      redirect_to [:admin, @category, @skill]
    else
      render :new
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
    @activities = Activity.all - @children
  end

  private

  def load_parents
    @category = Category.find params[:category_id]
    @skill = @category.skills.find params[:skill_id]
  end

  def require_outcome
    @outcome = @skill.outcomes.find params[:id]
  end

  def outcome_params
    params.require(:outcome).permit(:text)
  end
end
