class Admin::DayFeedbacksController < Admin::BaseController

  FILTER_BY_OPTIONS = [:mood, :day, :location_id, :archived?, :start_date, :end_date].freeze
  DEFAULT_PER = 20

  before_action :load_dayfeedback, only: [:archive, :unarchive, :update]

  def index
    # => A location wasn't provided, use the current_user's location as the default
    if params[:location_id].nil?
      params[:location_id] = current_user.location.id.to_s  
    end

    @day_feedbacks = DayFeedback.filter_by(filter_by_params)

    @paginated_day_feedbacks = @day_feedbacks.reverse_chronological_order
      .page(params[:page])
      .per(DEFAULT_PER)
  end

  def update
    if @day_feedback.update(day_feedback_params)
      respond_to do |format|
        format.json { respond_with_bip(@day_feedback) }
      end
    end
  end

  def archive
    @day_feedback.archive(current_user)
    if @day_feedback.save
      render nothing: true
    end
  end

  def unarchive
    @day_feedback.unarchive
    if @day_feedback.save
      render nothing: true
    end      
  end

  private

  def filter_by_params
    params.slice(*FILTER_BY_OPTIONS).select { |k,v| v.present? }
  end

  def load_dayfeedback
    @day_feedback = DayFeedback.find(params[:id])
  end

  def day_feedback_params
    params.require(:day_feedback).permit(:notes)
  end

end