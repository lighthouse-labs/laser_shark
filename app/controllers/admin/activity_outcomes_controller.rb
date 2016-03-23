class Admin::ActivityOutcomesController < Admin::BaseController

  before_action :require_activity_outcome, only: [:update, :destroy]

  def create
    @activity_outcome = ActivityOutcome.new(activity_outcome_params)
    #Need to know if this fails for some reason
    @activity_outcome.save!
    redirect_to(:back)
  end

  def update
    @activity_outcome.update(activity_outcome_params)
    #Need to know if this fails for some reason
    @activity_outcome.save!
    redirect_to(:back)
  end

  def destroy
    @activity_outcome.destroy
    redirect_to(:back)
  end

  protected

  def activity_outcome_params
    params.require(:activity_outcome).permit(:activity_id, :outcome_id)
  end

  def require_activity_outcome
    @activity_outcome = ActivityOutcome.find(params[:id])
  end

end