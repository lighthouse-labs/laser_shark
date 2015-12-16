class TeacherAssistanceStatsSerializer < ActiveModel::Serializer

  root false

  attributes :daily_stats, :overall_assistance_stats

  def daily_stats
    assistances.group('1').order('1').pluck("date_trunc('week', assistances.created_at)::date, COUNT(id)")
  end

  def overall_assistance_stats
    {total_count: assistances.count, average_l_score: assistances.average(:rating).to_f.round(2)}
  end

  protected

  def assistances
    object.teaching_assistances.completed
  end

end