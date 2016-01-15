class Admin::LocationsController < Admin::BaseController
  
  before_action :require_location, only: [:edit, :update, :destroy]

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

  def destroy
    if @location.destroy
      flash[:notice] = "Location #{@location.name} deleted."
    else
      flash[:notice] = "Unable to delete location #{@location.name}."
    end
    redirect_to [:admin, :locations]
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
