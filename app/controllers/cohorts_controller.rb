class CohortsController < ApplicationController

  before_action :require_teacher

  def switch_to
    @cohort = Cohort.find params[:id]
    session[:cohort_id] = @cohort.id
    current_user.selected_cohort = @cohort

    if current_user.save
      flash[:notice] = "Switched to #{@cohort.name} cohort!"
    else
      flash[:notice] = "Could not switch to #{@cohort.name} cohort!"
    end
    redirect_to day_path('today')
  end

  protected

  def require_teacher
    redirect_to :root, alert: 'Only teachers can do this!' unless teacher?
  end

end
