class Admin::OutcomesController < ApplicationController

  before_action :require_outcome, except: [:index, :new, :create]
  before_action :require_category, except: [:index, :new]

  def index
    if params[:outcome_text]
      @outcomes = Outcome.search(params[:outcome_text])
    else
      @outcomes = Outcome.all
    end
  end

  def show
    @activity_outcomes = @outcome.activity_outcomes.includes(:activity)
  end

  def create
    @outcome = Outcome.new(outcome_params)
    @outcome.category = @category
    if !@outcome.save
      flash[:notice] = "Outcome not created: #{@outcome.errors.full_messages[0]}"
    end
    redirect_to [:admin, @category]
  end

  def update
    if !@outcome.update(outcome_params)
      flash[:notice] = "Outcome not updated: #{@outcome.errors.full_messages[0]}"
    end
    redirect_to :back
  end

  def destroy
    @outcome.destroy
    redirect_to [:admin, @category, @skill]
  end

  def autocomplete
    @activities = (Activity.search(params[:term]) - @outcome.activities)
    render json: OutcomeAutocompleteSerializer.new(activities: @activities).activities.as_json, root: false
  end

  private

  def require_outcome
    @outcome = Outcome.includes(:skills).find(params[:id])
  end

  def require_category
    @category = Category.find(params[:category_id])
  end

  def outcome_params
    params.require(:outcome).permit(:text, skills_attributes: [:id, :text, :_destroy])
  end
end
