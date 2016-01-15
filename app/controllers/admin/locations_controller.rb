class Admin::LocationsController < Admin::BaseController
  
  before_action :require_location, only: [:edit, :update]

  def index
    @locations = Location.all
  end

  def new
    @location = Location.new
  end

  def edit
  end

  def create 
    @location = Location.new(location_params)
    if @location.save
      redirect_to [:edit, :admin, @location], notice: 'Created!'
    else
      render :new
    end
  end

  def update
    if @location.update(location_params)
      redirect_to [:edit, :admin, @location], notice: 'Updated!'
    else
      render :edit
    end
  end

  private

  def require_location
    @location = Location.find params[:id]
  end

  def location_params
    params.require(:location).permit(
      :name,
      :timezone,
      :calendar
    )
  end

end
