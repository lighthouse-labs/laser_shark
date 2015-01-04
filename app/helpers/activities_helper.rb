module ActivitiesHelper

  def markdown(content)
    options = {
      autolink: true,
      space_after_headers: true,
      fenced_code_blocks: true
    }
    @markdown ||= Redcarpet::Markdown.new(TargetBlankRenderer, options)
    @markdown.render(content)
  end

  def duration_in_hours(duration)
    number_with_precision (duration.to_f / 60), precision: 2, strip_insignificant_zeros: true
  end

  def duration activity
    duration = activity.duration
    duration < 60 ? duration.to_s << 'm' : duration_in_hours(duration) << "h"
  end

  def icon_for(activity)
    case activity.type.downcase
    when "assignment"
      'fa fa-code'
    when "task"
      'fa fa-flash'
    when "lecture"
      'fa fa-group'
    when "homework"
      'fa fa-moon-o'
    when "survey"
      'fa fa-list-alt'
    when "video"
      'fa fa-video-camera'
    when "test"
      'fa fa-gavel'
    end
  end

  def activity_type_options
    [
      'Assignment', 
      'Task',
      'Lecture',
      'Homework',
      'Video',
      'Test'
    ]
  end

end
