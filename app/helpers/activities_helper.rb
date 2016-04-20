module ActivitiesHelper

  def get_activity_path(activity)
    if activity.prep?
      prep_activity_path(:prep, activity)
    else
      day_activity_path(activity.day, activity)
    end
  end

  def markdown(content)
    options = {
      autolink: true,
      space_after_headers: true,
      fenced_code_blocks: true,
      tables: true
    }
    @markdown ||= Redcarpet::Markdown.new(CompassMarkdownRenderer, options)
    @markdown.render(content)
  end

  def duration_in_hours(duration)
    number_with_precision (duration.to_f / 60), precision: 2, strip_insignificant_zeros: true
  end

  def duration activity
    duration = activity.duration
    if duration <= 60
      'Short'
    elsif duration >= 180
      'Long'
    else
      'Medium'
    end
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
    when 'reading'
      'fa fa-book'
    when "test"
      'fa fa-gavel'
    when "quizactivity"
      'fa fa-question'
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
