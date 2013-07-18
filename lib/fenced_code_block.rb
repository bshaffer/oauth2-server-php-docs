require 'htmlentities'

class FencedCodeBlock < Nanoc3::Filter
  identifier :fenced_code_block

  def run(content, params={})
    content.gsub(/(^`{3}\s*(\S*)\s*$([^`]*)^`{3}\s*$)+?/m) {|match|

      lang_spec  = $2
      code_block = $3

      replacement = '<div class="code-container">'

      if lang_spec && lang_spec.length > 0
        replacement << '<div class="langspec">'
        replacement << lang_spec.capitalize
        replacement << '</div>'
      end

      replacement << '<pre class="highlight"><code class="language'

      if lang_spec && lang_spec.length > 0
        replacement << '-'
        replacement << lang_spec
      end

      replacement << '">'

      code_block.gsub!("[:backtick:]", "`")

      coder = ::HTMLEntities.new
      replacement << coder.encode(code_block)
      replacement << '</code></pre></div>'
    }
  end
end