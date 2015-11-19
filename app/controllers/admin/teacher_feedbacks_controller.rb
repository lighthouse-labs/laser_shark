class Admin::TeacherFeedbacksController < Admin::BaseController

  FILTER_BY_OPTIONS = [:teacher_id, :teacher_location_id, :start_date, :end_date].freeze

  def index
    if params[:teacher_location_id].nil?
      params[:teacher_location_id] = current_user.location.id.to_s  
    end
    @feedbacks = Feedback.teacher_feedbacks.completed.filter_by(filter_by_params)

    @overall_stats = {
      technical: @feedbacks.average(:technical_rating).to_f.round(2),
      style:     @feedbacks.average(:style_rating).to_f.round(2)
    }

    @feedbacks = @feedbacks.group_by(&:teacher)
  end

  private

  def filter_by_params
    params.slice(*FILTER_BY_OPTIONS).select { |k,v| v.present? }
  end

end