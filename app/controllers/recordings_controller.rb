class RecordingsController < ApplicationController

  before_action :teacher_required, only: [:edit, :update, :destroy, :new, :create]
  before_action :require_recording, only: [:edit, :update, :destroy]

  def show
    @recording = Recording.find(params[:id])
  end

  def new
    if params[:activity_id]
      @recording = Activity.find(params[:activity_id]).recordings.new
    else
      @recording = Recording.new
    end
    @recording.cohort = @cohort
    @recording.program = @program
  end

  def create
    @recording = Recording.new(recording_params)
    if @recording.save
      redirect_to recording_path(@recording), notice: 'Created!'
    else
      render :edit
    end
  end

  def edit
  end

  def update
    if @recording.update(recording_params)
      redirect_to recording_path(@recording), notice: 'Updated!'
    else
      render :edit
    end
  end

  def destroy
    path = recording_redirect_path(@recording.activity)
    if @recording.destroy
      redirect_to path, notice: 'Recording deleted'
    else
      redirect_to path, alert: 'Unable to delete recording'
    end
  end

  def recording_redirect_path(activity)
    activity ? day_activity_path(activity.day, activity) : recordings_path
  end
  helper_method :recording_redirect_path

  private

  def recording_params
    params.require(:recording).permit(
      :file_name,
      :recorded_at,
      :presenter_id,
      :cohort_id,
      :activity_id,
      :program_id,
      :title,
      :presenter_name
    )
  end

  def teacher_required
    redirect_to recordings_path unless teacher?
  end

  def require_recording
    @recording = Recording.find(params[:id])
  end

end
