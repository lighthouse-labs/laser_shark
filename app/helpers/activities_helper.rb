module ActivitiesHelper

  def markdown(content)
    options = {
      autolink: true,
      space_after_headers: true,
      fenced_code_blocks: true
    }
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
    @markdown.render(content)
  end

end
