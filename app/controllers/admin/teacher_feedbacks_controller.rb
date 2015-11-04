class Admin::TeacherFeedbacksController < Admin::BaseController

  FILTER_BY_OPTIONS = [:teacher_id, :location_id].freeze

  def index
    @teachers = Teacher.all.filter_by(filter_by_params)
  end

  private

  def filter_by_params
    params.slice(*FILTER_BY_OPTIONS).select { |k,v| v.present? }
  end

end