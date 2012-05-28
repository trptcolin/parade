require 'redcarpet'
require 'pygments.rb'

RubyPython.configure :python_exe => 'python2.6'

module ShowOff
  module Renderers
    class HTMLwithPygments < Redcarpet::Render::XHTML

      #
      # When rendering the markdown, the code should be rendered using the
      # Pygments highlight which corresponds to the ghf_marked.css
      #
      # Additionally a class `sh_javascript` or `sh_ruby` is added that will
      # assist in providing a system to provide live interactive elements
      # through the javascript defined in `showoff.js`.
      #
      # @param [String] code the fenced code to be highlighted
      # @param [String] language the name of the fenced code
      #
      def block_code(code, language)
        syntax_highlighted_html = Pygments.highlight code, :lexer => language,
          :options => {:encoding => 'utf-8'}

        syntax_highlighted_html.gsub('class="highlight"',"class=\"highlight sh_#{language}\"")
      end

      def self.render(content)
        markdown = Redcarpet::Markdown.new(Renderers::HTMLwithPygments,
          :fenced_code_blocks => true,
          :no_intra_emphasis => true,
          :autolink => true,
          :strikethrough => true,
          :lax_html_blocks => true,
          :superscript => true,
          :hard_wrap => true,
          :tables => true,
          :xhtml => true)
        markdown.render(content)
      end

    end
  end
end