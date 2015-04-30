class RecordingsController <ApplicationController

  def show
    @recording = Recording.find(params[:id])
  end

end