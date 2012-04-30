require 'redcarpet'
require 'pathname'
require 'pygments.rb'

class HTMLwithPygments < Redcarpet::Render::XHTML
  
  def doc_header

    ghf_css_path = File.join File.dirname(Pathname.new(__FILE__).realpath), '..',
      '..', 'views', 'ghf_marked.css'

    '<style>' + File.read(ghf_css_path) + '</style><div class="md"><article>'
  end
  
  def doc_footer
    '</article></div>'
  end
  
  def block_code(code, language)
    Pygments.highlight(code, :lexer => language, :options => {:encoding => 'utf-8'})
  end
end
