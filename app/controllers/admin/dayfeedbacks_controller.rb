class Admin::DayfeedbacksController < Admin::BaseController

  FILTER_BY_OPTIONS = [:mood, :day, :location_id].freeze
  DEFAULT_PER = 30

  def index
    @dayfeedbacks = DayFeedback.filter_by(filter_by_params)
    .reverse_chronological_order
    .page(params[:page])
    .per(DEFAULT_PER)

  end

  private

  def filter_by_params
    params.slice(*FILTER_BY_OPTIONS).select { |k,v| v.present? }
  end

end