class Admin::CurriculumFeedbacksController < Admin::BaseController

  FILTER_BY_OPTIONS = [:program, :completed?, :student_id, :student_location_id, :cohort_id, :start_date, :end_date, :day].freeze
  DEFAULT_PER = 10

  def index
    params[:student_location_id] = current_user.location.id.to_s if params[:student_location_id].nil?
    params[:completed?] = 'true' if params[:completed].nil?
    
    @feedbacks = Feedback.curriculum_feedbacks.filter_by(filter_by_params).order(order)
    @average_rating = @feedbacks.average(:average_rating).to_f.round(2)
    @feedbacks = @feedbacks.page(params[:page]).per(DEFAULT_PER)
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