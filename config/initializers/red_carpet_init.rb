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
      "<code class='#{class_name}'>#{ERB::Util.html_escape(code)}</code>" \
    "</pre>"
  end

  def preprocess(doc)
    # raise full_document.inspect
    regex = Regexp.new(/(^\?\?\?([a-zA-Z-]+)\s+(.*?)\s+^\?\?\?)/m)
    # raise match[0].inspect if match
    doc.gsub(regex) do
      code = Regexp.last_match[3]
      lang = Regexp.last_match[2]
      generate_toggle_block(block_code(code, lang))
    end
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

  def generate_toggle_block(content)
    "<div class='togglable-solution'>" \
    "<div class='alert alert-success answer' role='alert' style='display: none;'>" \
    "#{content}" \
    "</div>" \
    "<a class='btn btn-primary' onclick='$(this).closest(\".togglable-solution\").find(\".answer\").toggle();'>Toggle Answer</a>" \
    "</div>"
  end
  
end