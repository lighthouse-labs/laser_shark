module FeedbacksHelper
  def sortable(column, title = nil)
      title ||= column.titleize
      css_class = column == params[:sort] ? "current #{params[:direction]}" : nil
      direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"
      link_to title, {
        :sort => column, 
        :direction => direction, 
        :completed? => params[:completed?], 
        :student_id => params[:student_id],
        :teacher_id => params[:teacher_id],
        :location_id => params[:location_id],
        :cohort_id => params[:cohort_id]
        },
      {:class => css_class}
  end
end
