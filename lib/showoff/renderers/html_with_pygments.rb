require 'redcarpet'
require 'pathname'
require 'pygments.rb'

module ShowOff
  module Renderers
    class HTMLwithPygments < Redcarpet::Render::XHTML

      def doc_header

        ghf_css_path = File.join File.dirname(Pathname.new(__FILE__).realpath), '..',
          '..', 'views', 'ghf_marked.css'

        '<style>' + File.read(ghf_css_path) + '</style>'
      end

      def doc_footer
        ''
      end

      def block_code(code, language)
        syntax_highlighted_html = Pygments.highlight code, :lexer => language,
          :options => {:encoding => 'utf-8'}

        syntax_highlighted_html.gsub('class="highlight"',"class=\"highlight sh_#{language}\"")
      end
    end
  end
end