#Allows RedCarpet to pass the _blank link attribute for markdown link rendering 
#refer to solution at https://github.com/vmg/redcarpet/issues/85
class CompassMarkdownRenderer < Redcarpet::Render::HTML
  
  def initialize(extensions = {})
    super extensions.merge(link_attributes: {target: "_blank"})
  end

  def table(header, body)
    "<table class=\"table table-bordered\">" \
      "#{header}#{body}" \
    "</table>"
  end
  
end