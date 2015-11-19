class Admin::TeacherStatsController < Admin::BaseController

  before_action :require_teacher, except: [:index]

  def show
    
  end

  def index
    assistances_sub = Assistance.completed.group('1').select('assistances.assistor_id AS teacher_id, COUNT(assistances.id) AS assistance_count').to_sql
    feedback_sub = Feedback.teacher_feedbacks.completed.group('1').select('feedbacks.teacher_id, COUNT(feedbacks.id) AS feedback_count, ROUND(AVG(feedbacks.average_rating::numeric), 2)::float AS average_feedback_score').to_sql

    @teachers = Teacher.
      select(:id, :first_name, :last_name, :location_id, 'assistance_stats.assistance_count', 'feedback_stats.feedback_count', 'feedback_stats.average_feedback_score').
      joins("LEFT OUTER JOIN (#{assistances_sub}) assistance_stats ON assistance_stats.teacher_id = users.id").
      joins("LEFT OUTER JOIN (#{feedback_sub}) feedback_stats ON feedback_stats.teacher_id = users.id").
      order('feedback_stats.average_feedback_score DESC NULLS LAST')
  end

  def assistance
    @assistances = @teacher.teaching_assistances.completed

    @daily_stats = @assistances.group('1').order('1').pluck("date_trunc('week', assistances.created_at)::date, COUNT(id)")

    @overall_stats = {
      total_count: @assistances.count,
      average_l_score: @assistances.average(:rating).to_f.round(2)
    }

  end

  def feedback
    avg_col = "ROUND(AVG(average_rating), 2)::float"
    cols = "feedbacks.created_at::date, #{avg_col}"

    feedback = Feedback.teacher_feedbacks.completed
    
    @overall_stats = {
      mentor_average: feedback.filter_by_teacher(@teacher.id).assistance.pluck(avg_col),
      mentor_total: feedback.filter_by_teacher(@teacher.id).assistance.count,

      lecture_average: feedback.filter_by_teacher(@teacher.id).lecture.pluck(avg_col),
      lecture_total: feedback.filter_by_teacher(@teacher.id).lecture.count,

      direct_average: feedback.filter_by_teacher(@teacher.id).direct.pluck(avg_col),
      direct_total: feedback.filter_by_teacher(@teacher.id).direct.count
    }

    series = feedback.group('1').order('1')

    @series = {
      lecture: {
        teacher: series.lecture.filter_by_teacher(@teacher.id).pluck(cols),
        everyone: series.lecture.pluck(cols)
      },
      mentor: {
        teacher: series.assistance.filter_by_teacher(@teacher.id).pluck(cols),
        everyone: series.assistance.pluck(cols)
      }
    }
  end

  private

  def require_teacher
    @teacher = Teacher.find params[:id]

  end


end
