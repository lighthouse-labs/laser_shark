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

  def block_code(code, lang)
    class_name = ""
    if lang
      ar = lang.split('-') 
      class_name += ar.first if ar.first != "selectable"
      class_name += " allow-select" if ar.include?("selectable")
    end
    "<pre>" \
      "<code class='#{class_name}'>#{html_escape(code)}</code>" \
    "</pre>"
  end

  private

  def html_escape(string)
    string.gsub(/['&\"<>\/]/, {
      '&' => '&amp;',
      '<' => '&lt;',
      '>' => '&gt;',
      '"' => '&quot;',
      "'" => '&#x27;',
      "/" => '&#x2F;',
    })
  end
  
end