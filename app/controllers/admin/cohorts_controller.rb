class Admin::CohortsController < Admin::BaseController

  def index
    @cohorts = Cohort.all
  end

end
