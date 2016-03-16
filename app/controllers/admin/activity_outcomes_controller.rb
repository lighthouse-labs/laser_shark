class Admin::ActivityOutcomesController < ApplicationController

  def create
    @activity = Activity.find params[:activity_id]
    @outcome = Outcome.find params[:outcome_id]
    @activity_outcome = ActivityOutcome.new(activity: @activity, outcome: @outcome)
    @activity_outcome.save
  end

end