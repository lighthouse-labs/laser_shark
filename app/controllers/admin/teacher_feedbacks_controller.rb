class Admin::TeacherFeedbacksController < Admin::BaseController

  FILTER_BY_OPTIONS = [:teacher_id, :location_id, :start_date, :end_date].freeze

  def index
    @feedbacks = Feedback.teacher_feedbacks.completed.filter_by(filter_by_params).group_by(&:teacher)
  end

  private

  def filter_by_params
    params.slice(*FILTER_BY_OPTIONS).select { |k,v| v.present? }
  end

end