class Admin::CohortsController < Admin::BaseController

  before_action :require_cohort, only: [:edit, :update]

  def index
    @cohorts = Cohort.most_recent.all
  end

  def new
    @cohort = Cohort.new
  end

  def edit
  end

  def create 
    @cohort = Cohort.new(cohort_params)
    if @cohort.save
      redirect_to [:edit, :admin, @cohort], notice: 'Created!'
    else
      render :new
    end
  end

  def update
    if @cohort.update(cohort_params)
      redirect_to [:edit, :admin, @cohort], notice: 'Updated!'
    else
      render :edit
    end
  end

  private

  def require_cohort
    @cohort = Cohort.find params[:id]
  end

  def cohort_params
    params.require(:cohort).permit(
      :name,
      :start_date,
      :code,
      :program_id,
      :location_id,
      :teacher_email_group
    )
  end

end
