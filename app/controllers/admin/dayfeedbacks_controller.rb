class Admin::DayfeedbacksController < Admin::BaseController

  FILTER_BY_OPTIONS = [:mood, :day, :location_id, :archived?, :start_date, :end_date].freeze
  DEFAULT_PER = 20

  before_action :load_dayfeedback, only: [:archive, :unarchive]

  def index
    # => A location wasn't provided, use the current_user's location as the default
    if params[:location_id].nil?
      params[:location_id] = current_user.location.id.to_s  
    end
      @dayfeedbacks = DayFeedback.filter_by(filter_by_params)
    
    @paginated_dayfeedbacks = @dayfeedbacks.reverse_chronological_order
      .page(params[:page])
      .per(DEFAULT_PER)
  end

  def archive
    @dayfeedback.archive(current_user)
    if @dayfeedback.save
      render nothing: true
    end
  end

  def unarchive
    @dayfeedback.unarchive
    if @dayfeedback.save
      render nothing: true
    end      
  end

  private

  def filter_by_params
    params.slice(*FILTER_BY_OPTIONS).select { |k,v| v.present? }
  end

  def load_dayfeedback
    @dayfeedback = DayFeedback.find(params[:id])
  end

end