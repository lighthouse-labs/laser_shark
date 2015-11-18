class Admin::CurriculumFeedbacksController < Admin::BaseController

  FILTER_BY_OPTIONS = [:program, :completed?, :student_id, :student_location_id, :cohort_id, :start_date, :end_date].freeze
  DEFAULT_PER = 10

  def index
    if params[:student_location_id].nil?
      params[:student_location_id] = current_user.location.id.to_s  
    end
    @feedbacks = Feedback.curriculum_feedbacks.filter_by(filter_by_params)
      .order(order)
      .page(params[:page])
      .per(DEFAULT_PER)

    @average_rating = @feedbacks.average(:average_rating).to_f.round(2)
  end

  private

  def sort_column
    ["average_rating" "updated_at"].include?(params[:sort]) ? params[:sort] : "feedbacks.updated_at"
  end

  def sort_direction
    ["asc", "desc"].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def order
    sort_column + ' ' + sort_direction
  end

  def filter_by_params
    params.slice(*FILTER_BY_OPTIONS).select { |k,v| v.present? }
  end
end