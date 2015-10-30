class Admin::DayfeedbacksController < Admin::BaseController

  FILTER_BY_OPTIONS = [:mood, :day, :location_id, :archived?].freeze
  DEFAULT_PER = 20

  def index
    @dayfeedbacks = DayFeedback.filter_by(filter_by_params)

    # => A location wasn't provided, use the current_user's location as the default
    if params[:location_id].nil?
      @dayfeedbacks = @dayfeedbacks.filter_by_location(current_user.location.id)
    end
    
    @paginated_dayfeedbacks = @dayfeedbacks.reverse_chronological_order
      .page(params[:page])
      .per(DEFAULT_PER)
  end

  def destroy
    @dayfeedback = DayFeedback.find(params[:id])
    if @dayfeedback.archived?
      @dayfeedback.unarchive
    else
      @dayfeedback.archive(current_user)
    end
    if @dayfeedback.save
      render nothing: true
    end
  end

  private

  def filter_by_params
    params.slice(*FILTER_BY_OPTIONS).select { |k,v| v.present? }
  end

end