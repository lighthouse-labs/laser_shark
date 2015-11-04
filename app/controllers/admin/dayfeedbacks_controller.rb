class Admin::DayfeedbacksController < Admin::BaseController

  FILTER_BY_OPTIONS = [:program_id, :mood, :day, :location_id, :archived?].freeze
  DEFAULT_PER = 20

  before_action :load_dayfeedback, only: [:archive, :unarchive]

  def index
    @dayfeedbacks = DayFeedback.filter_by(filter_by_params)

    # => A location wasn't provided, use the current_user's location as the default
    if params[:location_id].nil?
      @dayfeedbacks = @dayfeedbacks.filter_by_location(current_user.location.id)
    end

    @total = @dayfeedbacks.count.to_f
    @happy = @dayfeedbacks.happy.count.to_f
    @ok = @dayfeedbacks.ok.count.to_f
    @sad = @dayfeedbacks.sad.count.to_f
    if @total > 0
      @stats = {
        happy_total: @happy.round(0),
        ok_total: @ok.round(0),
        sad_total: @sad.round(0),
        happy_percentage: (@happy/@total*100).round(0),
        ok_percentage: (@ok/@total*100).round(0),
        sad_percentage: (@sad/@total*100).round(0)
      }
    else
      @stats = Hash.new(0)
    end
    
    @dayfeedbacks = @dayfeedbacks.reverse_chronological_order
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