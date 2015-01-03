# Turn off wrapper div of class "field_with_errors" around form inputs (Rails default behavior)
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag.html_safe
end