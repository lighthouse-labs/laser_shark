class Admin::TeacherStatsController < Admin::BaseController

  before_action :require_teacher, except: [:index]

  def show
    
  end

  def index
    assistances_sub = Assistance.completed.group('1').select('assistances.assistor_id AS teacher_id, COUNT(assistances.id) AS assistance_count').to_sql
    feedback_sub = Feedback.teacher_feedbacks.completed.group('1').select('feedbacks.teacher_id, COUNT(feedbacks.id) AS feedback_count, ROUND(AVG(feedbacks.rating::numeric), 2)::float AS average_feedback_score').to_sql

    @teachers = Teacher.
      select(:id, :first_name, :last_name, :location_id, 'assistance_stats.assistance_count', 'feedback_stats.feedback_count', 'feedback_stats.average_feedback_score').
      joins("LEFT OUTER JOIN (#{assistances_sub}) assistance_stats ON assistance_stats.teacher_id = users.id").
      joins("LEFT OUTER JOIN (#{feedback_sub}) feedback_stats ON feedback_stats.teacher_id = users.id").
      order('feedback_stats.average_feedback_score DESC NULLS LAST')
  end

  def assistance
    render json: @teacher, serializer: TeacherAssistanceStatsSerializer
  end

  def feedback
    render json: @teacher, serializer: TeacherFeedbackStatsSerializer
  end

  private

  def require_teacher
    @teacher = Teacher.find params[:id]
  end
  
end
