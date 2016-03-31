class Admin::ActivityOutcomesController < Admin::BaseController
  
  before_action :load_activity_outcome, only: [:destroy]

  def create
    activity_outcome = ActivityOutcome.new(activity_outcome_params)
    activity_outcome.save
    redirect_to :back
  end

  def destroy
    @activity_outcome.destroy
    redirect_to :back
  end

  protected

  def load_activity_outcome
    @activity_outcome = ActivityOutcome.find params[:id]
  end

  def activity_outcome_params
    params.require(:activity_outcome).permit(:activity_id, :outcome_id)
  end

end